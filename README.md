# About

**clenv** is a wrapper that manages and runs arbitrary programs in individual environments.

Think of it like *virtualenv*, *rbenv*, *tfenv*, etc, but for any program at all. You can use *Extensions* to automatically install specific versions of programs, or build a custom environment. A wrapper mode seamlessly switches between versions in different directories.

# Requirements

 - A POSIX shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, etc)
 - `curl` or `wget` (if you use *Extensions*)

# Quick start

1. Install **clenv**
   ```bash
   $ sudo curl -fsSL -o /usr/local/bin/clenv https://raw.githubusercontent.com/peterwwillis/clenv/v1.3.0/clenv \
     && sudo chmod +x /usr/local/bin/clenv \
     && echo "00854335a8e649513a47507e7108f0facc2fee35667f0f0a99425e0f57fb4ef9  /usr/local/bin/clenv" | sha256sum -c \
     || { echo "FAILED CHECKSUM: REMOVING clenv" && sudo rm -f /usr/local/bin/clenv ; }
   /usr/local/bin/clenv: OK
   ```

2. Install and run a program with an *Extension*
   ```bash
   vagrant@devbox:~$ packer --version
   bash: packer: command not found
   vagrant@devbox:~$ clenv packer --version
   clenv: Looking for '/home/vagrant/.packer-version'
   clenv: Creating new environment '/home/vagrant/.clenv/packer'
   clenv: Loading extension 'packer' version '1.7.3'
   clenv: packer: Removing temporary download files
   clenv: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  10.6M      0  0:00:02  0:00:02 --:--:-- 10.6M
   clenv: packer: Unpacking to '/home/vagrant/.clenv/packer'
   clenv: packer: Installing symlink
   clenv: packer: Testing
   clenv: packer: Removing temporary download files
   clenv: packer: Installing wrapper
   clenv: Executing /home/vagrant/.clenv/packer/bin/packer
   1.7.3
   vagrant@devbox:~$ export PATH=$HOME/.clenv/.bin:$PATH
   vagrant@devbox:~$ packer --version
   clenv: Looking for '/home/vagrant/.packer-version'
   clenv: Executing /home/vagrant/.clenv/packer/bin/packer
   1.7.3
   ```

---

# Usage

   ```bash
   Usage: clenv [OPTS]
          clenv [OPTS] [CMD [ARGS ..]]
   Opts:
           -h                      This screen
           -i                      Clear environment variables. Must be first argument
           -l [ENVIRON]            List environments
           -n ENVIRON              Create a new environment ENVIRON
           -E EXT[=V]              Use (optional) version V of extension EXT
           -e ENVIRON              Use environment ENVIRON
           -W                      Disables wrapper mode
           -f                      Force mode
           -V                      Version of clenv
           -q                      Quiet mode
   ```

Available extensions:
 - **aws**
 - **ansible**
 - **docker-compose**
 - **packer**
 - **saml2aws**
 - **terraform**
 - **terraformer**
 - **yq**

(Don't see an extension you want? Check out the [.ext/](./.ext/) directory,
cut me a Pull Request, I'll merge it!)

---

## How it works

**clenv** keeps a directory *$CLENV_DIR* (default: *$HOME/.clenv/*). In that
directory are sub-directories called *Environment*s.

Each *Environment* directory has at least two files:
 - `bin/` : *Extensions* install symlinks into this directory. You can put any programs you like here.
 - `.env` : A mini shell script to set environment variables that can be customized as you wish.

When **clenv** is run with a `CMD` argument, it looks for an *Environment* with the
same name. If found, it loads that *Environment*. If not found, **clenv** looks for
an *Extension* of the same name. If found, it uses that *Extension* to install a
program in a new *Environment*. If no *Extension* is found, **clenv** errors.

*Extensions* look up the version of a program, download it, install it in an
*Environment*, and set up a wrapper in `~/.clenv/.bin/` pointing to the program
in the *Environment*, so you can add this directory to your *$PATH* and run any
programs installed by **clenv**.

Once an *Environment* is found, the `.env` is loaded from it, the *$PATH* environment
variable is changed to include the `bin/` directory, and `CMD` and any arguments
are executed.

**clenv** also looks for a file `.EXTENSION-version` in the current and parent
directories. If it finds one, the contents of that file is the version to use to
create a new *Environment* for that *Extension* and version. This way you can
pin different versions of a program in different directories and **clenv** will
automatically install and run the right version.


### Using Extensions

**clenv** will download *Extensions* with `curl` or `wget` from a URL
`$CLENV_HTTP_PATH/.ext/EXTENSION`. Override *$CLENV_HTTP_PATH* if you want
to provide your own *Extension* path or URL.

You can also put extensions directly into your `~/.clenv/.ext/` directory.
These are not overwritten unless you pass the `-f` option to **clenv**.

By default, *Extensions* and *Environments* use the same name as a `CMD`. But
sometimes this doesn't work well, so all 3 can have different names.

Use the `-E` option to specify an *Extension* name. If you add `=VERSION` to the
*Extension* name, it will install that version of the intended program.
   ```bash
   $ clenv -E aws=2.0.34
   ```
This is still using the default *Environment* name (same as the *Extension*
and `CMD`). To use a custom *Environment* name, pass the `-e` option.
   ```bash
   $ clenv -E aws=2.0.34 -e some-aws-env
   ```
If you *don't* pass a version with `-E`, and a `.EXTENSION-version` file is found,
**clenv** will make an *Environment* named `$EXTENSION=$VERSION`. This happens
automatically whether you're calling `clenv` directly, or using the `~/.clenv/.bin/`
wrapper. (To disable it completely, use the `-W` option)
   ```bash
   $ echo "2.0.50" > .aws-version
   $ aws
   clenv: Looking for '/home/vagrant/.aws-version'
   clenv: Found '/home/vagrant/.aws-version' = '2.0.50'
   clenv: Creating new environment '/home/vagrant/.clenv/aws=2.0.50'
   clenv: Loading extension 'aws' version '2.0.50'
   clenv: aws: Removing temporary download files
   clenv: aws: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 32.2M  100 32.2M    0     0  9667k      0  0:00:03  0:00:03 --:--:-- 9664k
   clenv: aws: Unpacking to '/home/vagrant/.clenv/aws=2.0.50'
   clenv: aws: Installing symlink
   clenv: aws: Testing
   clenv: aws: Removing temporary download files
   clenv: aws: Installing wrapper
   clenv: Executing /home/vagrant/.clenv/aws=2.0.50/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```


### Manually setting up an *Environment*

1. Create a new *Environment*. For this example we'll call it just "aws",
   but you could also give it a more descriptive name, like "aws=2.0.50".
   ```bash
   $ clenv -n aws
   ```

2. Manually install a program (like `aws`) in the new `bin/` directory of the new *Environment*
   (`~/.clenv/aws/bin/`).

3. If you want, you can customize the environment used by editing the
   `~/.clenv/aws/.env` file. `clenv` loads this as a shell script before running
   your program.

4. Run your program with `clenv`
   ```bash
   $ clenv -e aws aws --version
   clenv: Executing /home/vagrant/.clenv/aws/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

### List environments

Let's see the *Environment*s we've created so far:
   ```bash
   $ clenv -l
   aws
   aws=2.0.50
   ```

---

## Testing

Run `make` in this directory to run all the tests. See [.ext/tests/](./.ext/tests/) for details.

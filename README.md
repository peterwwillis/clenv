# About

**clenv** is a tool to manage arbitrary applications (and versions) in individual environments. Inspired by programs like `rbenv`, `tfenv`, `virtualenv`, etc.

# Requirements

 - A POSIX shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, etc)
 - `curl` (if you use *Extensions*, which you probably want to)

# Features
 - *Extensions* to automate downloading & installing any application
 - Pin versions with `.EXTENSION-version` files
 - Wrappers in `~/.clenv/.bin` allow your shell to automatically find installed applications
 - Small codebase, minimal dependencies
 - Customize environments to your needs

# Quick start

1. Install **clenv**
   ```bash
   $ sudo curl -fsSL -o /usr/local/bin/clenv https://raw.githubusercontent.com/peterwwillis/clenv/v2.3.0/clenv \
     && sudo chmod +x /usr/local/bin/clenv \
     && echo "63eb86730f46ea61e0224c66744ee8ddf5488890f56baba9631435bc0c607d1a  /usr/local/bin/clenv" | sha256sum -c \
     || { echo "FAILED CHECKSUM: REMOVING clenv" && sudo rm -f /usr/local/bin/clenv ; }
   /usr/local/bin/clenv: OK
   ```

2. Install and run an application with an *Extension*
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

3. Pin the version of the *Extension*
   ```bash
   vagrant@devbox:~$ echo "1.7.3" > .packer-version
   vagrant@devbox:~$ packer --version
   clenv: Looking for '/home/vagrant/.packer-version'
   clenv: Found '/home/vagrant/.packer-version' = '1.7.3'
   clenv: Installing extention 'packer'
   clenv: Creating new environment '/home/vagrant/.clenv/packer=1.7.3'
   clenv: Loading extension 'packer' version '1.7.3'
   clenv: packer: Removing temporary download files
   clenv: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  8123k      0  0:00:03  0:00:03 --:--:-- 8121k
   clenv: packer: Unpacking to '/home/vagrant/.clenv/packer=1.7.3'
   clenv: packer: Installing locally
   clenv: packer: Testing
   clenv: packer: Removing temporary download files
   clenv: packer: Installing wrapper
   clenv: Executing /home/vagrant/.clenv/packer=1.7.3/bin/packer
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
           -r FILE                 Install a list of extensions from FILE
           -X CMD [ARG ..]         (internal function) Run command for an extention
           -W                      Disables wrapper mode
           -f                      Force mode
           -V                      Version of clenv
           -q                      Quiet mode
   ```

Available *Extensions*: **ansible** - **aws** - **docker-compose** - **packer** - **saml2aws** - **terraform-docs** - **terraformer** - **terraform** - **terragrunt** - **tflint** - **tfsec** - **yq**

(Don't see an *Extension* you want? Check out the [.ext/](./.ext/) directory,
cut me a Pull Request, I'll merge it!)

---

## How it works

### What are Environments?

*Environments* are basically just directories with a couple files in them. They
keep some configuration, and any programs you install in them. **clenv** loads 
the configuration and runs your program.

*Environments* are kept in sub-directories of *$CLENV_DIR* (default: *$HOME/.clenv/*).
Each *Environment* has at least two files:
 - `bin/` : applications (or symlinks to applications) installed here.
 - `.env` : A shell script to set environment variables at run time.

### What are Extensions?

Normally you might use your operating system's package manager to install a 
program, but sometimes those packages don't exist or are out of date. 
*Extensions* fill that void by automating the process of downloading, installing
and running specific versions of programs.

For convenience, *Extensions* also install a wrapper for your program in a common
directory (`$HOME/.clenv/.bin/`) that you can add to your `$PATH`. This way you
can automatically run the right version of your program.

If a file `.EXTENSION-version` exists in the current or a parent directory, the
contents of the file is the version of an *Extension* to install. If you specify
a version in the `-E` option, this does not happen, and the `-W` option disable
it entirely.

### How do I install and run a program?

When you run a command like `clenv CMD`, this happens:

 1. **clenv** looks for an *Environment* with the same name (`$CLENV_DIR/CMD`).
    If found, it will load that *Environment* configuration (`$CLENV_DIR/CMD/.env`).
    Then it will try to run program `CMD`.

 2. If the *Environment* was not found, **clenv** looks for an *Extension* of the
    same name (`$CLENV_HTTP_PATH/.ext/CMD.ex`). If found, it downloads the 
    *Extension*, uses it to install `CMD` in an *Environment* of the same name,
    then follows step #1.

 3. If no *Extension* or *Environment* is found, **clenv** dies.
    ```bash
    $ clenv foobar
    clenv: Looking for '/home/vagrant/.foobar-version'
    clenv: Installing extention 'foobar'
    curl: (22) The requested URL returned error: 404
    ```


### Using Extensions

**clenv** will download *Extensions* with `curl` from a URL
`$CLENV_HTTP_PATH/.ext/EXTENSION`. Override *$CLENV_HTTP_PATH* if you want
to provide your own *Extension* path or URL.

You can also put extensions directly into your `~/.clenv/.ext/` directory.
These are not overwritten unless you pass the `-f` option to **clenv**.

By default, *Extensions* and *Environments* use the same name as a `CMD`. But
sometimes this doesn't work well, so all 3 can have different names.

Use the `-E` option to specify an *Extension* name. If you add `=VERSION` to the
*Extension* name, it will install that version of the application.
   ```bash
   $ clenv -E aws=2.0.34
   ```
This is still using the default *Environment* name (same as the *Extension*
and `CMD`). To use a custom *Environment* name, pass the `-e` option.
   ```bash
   $ clenv -E aws=2.0.34 -e some-aws-env
   ```
To execute a program in this new custom *Environment*, just pass the `-e` option
and a command to run.
   ```bash
   $ clenv -e some-aws-env aws --version
   ```
Remember: `clenv` uses the `.env` file in the *Environment* to set the *$PATH* to
include `~/.clenv/some-aws-env/bin/`. If the file you want to execute isn't in that
directory, you'll have to modify the `.env` to include the path to your
application in your *Environment*.

If you *don't* pass a version with `-E`, and a `.EXTENSION-version` file is found,
**clenv** will make an *Environment* named `$EXTENSION=$VERSION`. This happens
automatically whether you're calling `clenv` directly, or using the `~/.clenv/.bin/`
wrapper. (To disable it completely, use the `-W` option)


### Manually setting up an *Environment*

You actually don't need to use *Extensions* at all to take advantage of **clenv**.
You can manually set up an *Environment* and call programs within it.

1. Create a new *Environment*. For this example we'll call it just "aws",
   but you could also give it a more descriptive name, like "aws=2.0.50".
   ```bash
   $ clenv -n aws-foo
   ```

2. Manually install an application (like `aws`) in the new `bin/` directory of the new *Environment*
   (`~/.clenv/aws-foo/bin/`).

3. If you want, you can customize the environment used by editing the
   `~/.clenv/aws-foo/.env` file. `clenv` loads this as a shell script before running
   your application.

4. Run your application with `clenv`
   ```bash
   $ clenv -e aws-foo aws --version
   clenv: Executing /home/vagrant/.clenv/aws-foo/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

### List environments

Let's see the *Environment*s we've created so far:
   ```bash
   $ clenv -l
   aws
   aws-foo
   aws=2.0.50
   ```

### List extensions

Want to know what extensions are available?
   ```bash
   $ clenv -L
   ansible
   aws
   docker-compose
   packer
   saml2aws
   terraform
   terraform-docs
   terraformer
   terragrunt
   test
   tflint
   tfsec
   yq
   ```
How about the available versions of an extension?
   ```bash
   $ clenv -L terraform | head
   1.0.1
   1.0.0
   0.15.5
   0.15.4
   0.15.3
   0.15.2
   0.15.1
   0.15.0
   0.14.11
   0.14.10
   ```

### Be quiet

To silence the normal output of **clenv**, pass the `-q` option, or set environment
variable `CLENV_QUIET=1`.

---

## Testing

Run `make` in this directory to run all the tests. See [.ext/tests/](./.ext/tests/) for details.

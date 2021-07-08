# About

**cliv** is a tool to manage arbitrary applications (and versions) in individual environments. Inspired by programs like `rbenv`, `tfenv`, `virtualenv`, etc.

# Requirements

 - A POSIX shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, etc)
 - `curl` (if you use *Extensions*, which you probably want to)

# Features
 - Use *Extensions* to automate downloading & installing any application (**ansible**, **aws**, **docker-compose**, **eksctl**, **helm**, **istioctl**, **kubectl**, **packer**, **saml2aws**, **terraform-docs**, **terraformer**, **terraform**, **terragrunt**, **tflint**, **tfsec**, **yq**)
 - Install custom *Extensions* from GitHub (`cliv -E github.com/foo/bar`)
 - Pin versions with `.EXTENSION-version` files
 - Wrappers in `~/.cliv/.bin` allow your shell to automatically find installed applications
 - Small codebase, minimal dependencies
 - Customize environments to your needs

# Quick start

1. Install **cliv**
   ```bash
   $ sudo curl -fsSL -o /usr/local/bin/cliv https://raw.githubusercontent.com/peterwwillis/cliv/v2.4.0/cliv \
     && sudo chmod +x /usr/local/bin/cliv \
     && echo "3708fa6d60f90d2ca610337260b583afb945de1433344ad20bd06c23ccdebcdc  /usr/local/bin/cliv" | sha256sum -c \
     || { echo "FAILED CHECKSUM: REMOVING cliv" && sudo rm -f /usr/local/bin/cliv ; }
   /usr/local/bin/cliv: OK
   ```

2. Install and run an application with an *Extension*
   ```bash
   vagrant@devbox:~$ packer --version
   bash: packer: command not found
   
   vagrant@devbox:~$ cliv packer --version
   cliv: Creating new environment '/home/vagrant/.cliv/packer'
   cliv: Loading extension 'packer' version '1.7.3'
   cliv: packer: Removing temporary download files
   cliv: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  10.6M      0  0:00:02  0:00:02 --:--:-- 10.6M
   cliv: packer: Unpacking to '/home/vagrant/.cliv/packer'
   cliv: packer: Installing symlink
   cliv: packer: Testing
   cliv: packer: Removing temporary download files
   cliv: packer: Installing wrapper
   cliv: Executing /home/vagrant/.cliv/packer/bin/packer
   1.7.3

   vagrant@devbox:~$ export PATH=$HOME/.cliv/.bin:$PATH

   vagrant@devbox:~$ packer --version
   cliv: Executing /home/vagrant/.cliv/packer/bin/packer
   1.7.3
   ```

3. Pin the version of the *Extension*
   ```bash
   vagrant@devbox:~$ echo "1.7.3" > .packer-version
   vagrant@devbox:~$ packer --version
   cliv: Found '/home/vagrant/.packer-version' = '1.7.3'
   cliv: Installing extention 'packer'
   cliv: Creating new environment '/home/vagrant/.cliv/packer=1.7.3'
   cliv: Loading extension 'packer' version '1.7.3'
   cliv: packer: Removing temporary download files
   cliv: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  8123k      0  0:00:03  0:00:03 --:--:-- 8121k
   cliv: packer: Unpacking to '/home/vagrant/.cliv/packer=1.7.3'
   cliv: packer: Installing locally
   cliv: packer: Testing
   cliv: packer: Removing temporary download files
   cliv: packer: Installing wrapper
   cliv: Executing /home/vagrant/.cliv/packer=1.7.3/bin/packer
   1.7.3
   ```

---

# Usage

   ```bash
   Usage: cliv [OPTS]
          cliv [OPTS] [CMD [ARGS ..]]
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
           -V                      Version of cliv
           -q                      Quiet mode
   ```

---

## How it works

### What are Environments?

*Environments* are basically just directories with a couple files in them. They
keep some configuration, and any programs you install in them. **cliv** loads 
the configuration and runs your program.

*Environments* are kept in sub-directories of *$CLIV_DIR* (default: *$HOME/.cliv/*).
Each *Environment* has at least two files:
 - `bin/` : applications (or symlinks to applications) installed here.
 - `.env` : A shell script to set environment variables at run time.

### What are Extensions?

Normally you might use your operating system's package manager to install a 
program, but sometimes those packages don't exist or are out of date. 
*Extensions* fill that void by downloading, installing and running specific
versions of programs. (There is no dependency management, so this is mostly
for statically-compiled binaries)

For convenience, *Extensions* also install a wrapper for your program in a common
directory (`$HOME/.cliv/.bin/`) that you can add to your `$PATH`. This way you
can automatically run the right version of your program.

If a file `.EXTENSION-version` exists in the current or a parent directory, the
contents of the file becomes the version of an *Extension* to install. If you
specify a version in the `-E` option, this does not happen, and the `-W` option
disables it entirely.

(Don't see an *Extension* you want? Check out the [.ext/](./.ext/) directory,
cut me a Pull Request, I'll merge it! Or create your own via a GitHub repository)

### How do I install and run a program?

When you run a command like `cliv CMD`, this happens:

 1. **cliv** looks for an *Environment* with the same name (`$CLIV_DIR/CMD`).
    If found, it will load that *Environment* configuration (`$CLIV_DIR/CMD/.env`).
    Then it will try to run program `CMD`.

 2. If the *Environment* was not found, **cliv** looks for an *Extension* of the
    same name (`$CLIV_HTTP_PATH/.ext/CMD.ex`). If found, it downloads the 
    *Extension*, uses it to install `CMD` in an *Environment* of the same name,
    then follows step #1.

 3. If no *Extension* or *Environment* is found, **cliv** dies.
    ```bash
    $ cliv foobar
    cliv: Installing extention 'foobar'
    curl: (22) The requested URL returned error: 404
    ```


### Using Extensions

**cliv** will download *Extensions* with `curl` from a URL
`$CLIV_HTTP_PATH/.ext/EXTENSION.ex`. Override *$CLIV_HTTP_PATH* if you want
to provide your own *Extension* path or URL.

You can also put extensions directly into your `~/.cliv/.ext/` directory.
These are not overwritten unless you pass the `-f` option to **cliv**.

By default, *Extensions* and *Environments* use the same name as a `CMD`. But
sometimes this doesn't work well, so all 3 can have different names.

Use the `-E` option to specify an *Extension* name. If you add `=VERSION` to the
*Extension* name, it will install that version of the application.
   ```bash
   $ cliv -E aws=2.0.34
   ```
This is still using the default *Environment* name (same as the *Extension*
and `CMD`). To use a custom *Environment* name, pass the `-e` option.
   ```bash
   $ cliv -E aws=2.0.34 -e some-aws-env
   ```
To execute a program in this new custom *Environment*, just pass the `-e` option
and a command to run.
   ```bash
   $ cliv -e some-aws-env aws --version
   ```
Remember: `cliv` uses the `.env` file in the *Environment* to set the *$PATH* to
include `~/.cliv/some-aws-env/bin/`. If the file you want to execute isn't in that
directory, you'll have to modify the `.env` to include the path to your
application in your *Environment*.

If you *don't* pass a version with `-E`, and a `.EXTENSION-version` file is found,
**cliv** will make an *Environment* named `$EXTENSION=$VERSION`. This happens
automatically whether you're calling `cliv` directly, or using the `~/.cliv/.bin/`
wrapper. (To disable it completely, use the `-W` option)

**New in cliv 2.4.0:** You can now specify a GitHub repository as an *Extension*
name, and the tag/branch with '@BRANCH'. Example:
   ```bash
   $ cliv -E github.com/peterwwillis/cliv-test-ext
   $ cliv -E github.com/peterwwillis/cliv-test-ext@v2.4.0
   $ cliv -E github.com/peterwwillis/cliv-test-ext=4.9.6
   $ cliv -E github.com/peterwwillis/cliv-test-ext@v2.4.0=4.9.6
   ```
See [.ext/README.md](./ext/README.md) for details about how to create these extensions.


### Manually setting up an *Environment*

You actually don't need to use *Extensions* at all to take advantage of **cliv**.
You can manually set up an *Environment* and call programs within it.

1. Create a new *Environment*. For this example we'll call it just "aws",
   but you could also give it a more descriptive name, like "aws=2.0.50".
   ```bash
   $ cliv -n aws-foo
   ```

2. Manually install an application (like `aws`) in the new `bin/` directory of the new *Environment*
   (`~/.cliv/aws-foo/bin/`).

3. If you want, you can customize the environment used by editing the
   `~/.cliv/aws-foo/.env` file. `cliv` loads this as a shell script before running
   your application.

4. Run your application with `cliv`
   ```bash
   $ cliv -e aws-foo aws --version
   cliv: Executing /home/vagrant/.cliv/aws-foo/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

### List *Environments*

Let's see the *Environments* we've created so far:
   ```bash
   $ cliv -l
   aws
   aws-foo
   aws=2.0.50
   cliv-test-ext
   ```

### List *Extensions*

Want to know what extensions are available?
   ```bash
   $ cliv -L
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
   $ cliv -L terraform | head
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

To silence the normal output of **cliv**, pass the `-q` option, or set environment
variable `CLIV_QUIET=1`.

---

## Testing

Run `make` in this directory to run all the tests. See [.ext/tests/](./.ext/tests/) for details.

# About

**clinst** is a tool to manage arbitrary applications (and versions) in individual environments. Inspired by programs like `rbenv`, `tfenv`, `virtualenv`, etc.

# Requirements

 - A POSIX shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, etc)
 - `curl` (if you use *Extensions*, which you probably want to)

# Features
 - Use *Extensions* to automate downloading & installing any application (**ansible**, **aws**, **docker-compose**, **eksctl**, **helm**, **istioctl**, **kind**, **krew**, **kubectl**, **packer**, **saml2aws**, **terraform-docs**, **terraformer**, **terraform**, **terraform_landscape**, **terragrunt**, **tflint**, **tfsec**, **ydiff**, **yq**)
 - Install custom *Extensions* from GitHub (`clinst -E github.com/foo/bar`)
 - Pin versions with `.EXTENSION-version` files
 - Wrappers in `~/.clinst/.bin` allow your shell to automatically find installed applications
 - Small codebase, minimal dependencies
 - Customize environments to your needs

# Quick start

1. Install **clinst**
   ```bash
   $ sudo curl -fsSL -o /usr/local/bin/clinst https://raw.githubusercontent.com/peterwwillis/clinst/v3.0.0/clinst \
     && sudo chmod +x /usr/local/bin/clinst \
     && echo "e8a600cca7c68f72ff2412a1d1aae3e1ca1ff7da0c28884a2739343e7164cf82  /usr/local/bin/clinst" | sha256sum -c \
     || { echo "FAILED CHECKSUM: REMOVING clinst" && sudo rm -f /usr/local/bin/clinst ; }
   /usr/local/bin/clinst: OK
   ```

2. Install and run an application with an *Extension*
   ```bash
   vagrant@devbox:~$ packer --version
   bash: packer: command not found
   
   vagrant@devbox:~$ clinst packer --version
   clinst: Creating new environment '/home/vagrant/.clinst/packer'
   clinst: Loading extension 'packer' version '1.7.3'
   clinst: packer: Removing temporary download files
   clinst: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  10.6M      0  0:00:02  0:00:02 --:--:-- 10.6M
   clinst: packer: Unpacking to '/home/vagrant/.clinst/packer'
   clinst: packer: Installing symlink
   clinst: packer: Testing
   clinst: packer: Removing temporary download files
   clinst: packer: Installing wrapper
   clinst: Executing /home/vagrant/.clinst/packer/bin/packer
   1.7.3

   vagrant@devbox:~$ export PATH=$HOME/.clinst/.bin:$PATH

   vagrant@devbox:~$ packer --version
   clinst: Executing /home/vagrant/.clinst/packer/bin/packer
   1.7.3
   ```

3. Pin the version of the *Extension*
   ```bash
   vagrant@devbox:~$ echo "1.7.3" > .packer-version
   vagrant@devbox:~$ packer --version
   clinst: Found '/home/vagrant/.packer-version' = '1.7.3'
   clinst: Installing extention 'packer'
   clinst: Creating new environment '/home/vagrant/.clinst/packer=1.7.3'
   clinst: Loading extension 'packer' version '1.7.3'
   clinst: packer: Removing temporary download files
   clinst: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.2M  100 30.2M    0     0  8123k      0  0:00:03  0:00:03 --:--:-- 8121k
   clinst: packer: Unpacking to '/home/vagrant/.clinst/packer=1.7.3'
   clinst: packer: Installing locally
   clinst: packer: Testing
   clinst: packer: Removing temporary download files
   clinst: packer: Installing wrapper
   clinst: Executing /home/vagrant/.clinst/packer=1.7.3/bin/packer
   1.7.3
   ```

---

# Usage

   ```bash
   Usage: clinst [OPTS]
          clinst [OPTS] [CMD [ARGS ..]]
   Opts:
           -h                      This screen
           -i                      Clear environment variables. Must be first argument
           -l [ENVIRON]            List environments
           -L [EXT]                List remote extensions
           -n ENVIRON              Create a new environment ENVIRON
           -E EXT[=V]              Use (optional) version V of extension EXT
           -e ENVIRON              Use environment ENVIRON
           -D EXT=V                Make version V the default wrapper for EXT
           -r FILE                 Install a list of extensions from FILE
           -X CMD [ARG ..]         (internal function) Run command for an extention
           -W                      Disables wrapper mode
           -f                      Force mode
           -V                      Version of clinst
           -q                      Quiet mode
   ```

---

## How it works

### What are Environments?

*Environments* are basically just directories with a couple files in them. They
keep some configuration, and any programs you install in them. **clinst** loads 
the configuration and runs your program.

*Environments* are kept in sub-directories of *$CLINST_DIR* (default: *$HOME/.clinst/*).
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
directory (`$HOME/.clinst/.bin/`) that you can add to your `$PATH`. This way you
can automatically run the right version of your program.

Since there is only one wrapper for all the possible *Environments* of an 
*Extension* (only one '~/.clinst/.bin/terraform' for all the installed versions of
Terraform) you can choose which *Environment* the wrapper runs in two ways:

1. The *Extension* installs a wrapper that points to a specific *Environment*. You
   can change the default *Environment* used by the wrapper using the `-D` option.
   ```
   vagrant@devbox $ terraform --version
   clinst: Executing /home/vagrant/.clinst/terraform=0.11.15/bin/terraform
   Terraform v0.11.15
   vagrant@devbox $ clinst -D terraform=0.12.31
   clinst: Switching default environment for extension terraform to terraform=0.12.31
   clinst: terraform: Installing wrapper
   vagrant@devbox $ terraform --version
   clinst: Executing /home/vagrant/.clinst/terraform=0.12.31/bin/terraform
   Terraform v0.12.31
   ```

2. If a file `.EXTENSION-version` exists in the current or a parent directory, the
   contents of the file becomes the version of an *Extension* to install. If you
   specify a version in the `-E` option, this does not happen, and the `-W` option
   disables it entirely.

(Don't see an *Extension* you want? Check out the [.clext/](./.clext/) directory,
cut me a Pull Request, I'll merge it! Or create your own via a GitHub repository)

### How do I install and run a program?

When you run a command like `clinst CMD`, this happens:

 1. **clinst** looks for an *Environment* with the same name (`$CLINST_DIR/CMD`).
    If found, it will load that *Environment* configuration (`$CLINST_DIR/CMD/.env`).
    Then it will try to run program `CMD`.

 2. If the *Environment* was not found, **clinst** looks for an *Extension* of the
    same name (`$CLINST_HTTP_PATH/.clext/CMD.ex`). If found, it downloads the 
    *Extension*, uses it to install `CMD` in an *Environment* of the same name,
    then follows step #1.

 3. If no *Extension* or *Environment* is found, **clinst** dies.
    ```bash
    $ clinst foobar
    clinst: Installing extention 'foobar'
    curl: (22) The requested URL returned error: 404
    ```


### Using Extensions

**clinst** will download *Extensions* with `curl` from a URL
`$CLINST_HTTP_PATH/.clext/EXTENSION.ex`. Override *$CLINST_HTTP_PATH* if you want
to provide your own *Extension* path or URL.

You can also put extensions directly into your `~/.clinst/.clext/` directory.
These are not overwritten unless you pass the `-f` option to **clinst**.

By default, *Extensions* and *Environments* use the same name as a `CMD`. But
sometimes this doesn't work well, so all 3 can have different names.

Use the `-E` option to specify an *Extension* name. If you add `=VERSION` to the
*Extension* name, it will install that version of the application.
   ```bash
   $ clinst -E aws=2.0.34
   ```
This is still using the default *Environment* name (same as the *Extension*
and `CMD`). To use a custom *Environment* name, pass the `-e` option.
   ```bash
   $ clinst -E aws=2.0.34 -e some-aws-env
   ```
To execute a program in this new custom *Environment*, just pass the `-e` option
and a command to run.
   ```bash
   $ clinst -e some-aws-env aws --version
   ```
Remember: `clinst` uses the `.env` file in the *Environment* to set the *$PATH* to
include `~/.clinst/some-aws-env/bin/`. If the file you want to execute isn't in that
directory, you'll have to modify the `.env` to include the path to your
application in your *Environment*.

If you *don't* pass a version with `-E`, and a `.EXTENSION-version` file is found,
**clinst** will make an *Environment* named `$EXTENSION=$VERSION`. This happens
automatically whether you're calling `clinst` directly, or using the `~/.clinst/.bin/`
wrapper. (To disable it completely, use the `-W` option)

**New in clinst 2.4.0:** You can now specify a GitHub repository as an *Extension*
name, and the tag/branch with '@BRANCH'. Example:
   ```bash
   $ clinst -E github.com/peterwwillis/clinst-test-ext
   $ clinst -E github.com/peterwwillis/clinst-test-ext@v2.4.0
   $ clinst -E github.com/peterwwillis/clinst-test-ext=4.9.6
   $ clinst -E github.com/peterwwillis/clinst-test-ext@v2.4.0=4.9.6
   ```
See [.clext/README.md](./.clext/README.md) for details about how to create these extensions.


### Manually setting up an *Environment*

You actually don't need to use *Extensions* at all to take advantage of **clinst**.
You can manually set up an *Environment* and call programs within it.

1. Create a new *Environment*. For this example we'll call it just "aws",
   but you could also give it a more descriptive name, like "aws=2.0.50".
   ```bash
   $ clinst -n aws-foo
   ```

2. Manually install an application (like `aws`) in the new `bin/` directory of the new *Environment*
   (`~/.clinst/aws-foo/bin/`).

3. If you want, you can customize the environment used by editing the
   `~/.clinst/aws-foo/.env` file. `clinst` loads this as a shell script before running
   your application.

4. Run your application with `clinst`
   ```bash
   $ clinst -e aws-foo aws --version
   clinst: Executing /home/vagrant/.clinst/aws-foo/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

### List *Environments*

Let's see the *Environments* we've created so far:
   ```bash
   $ clinst -l
   aws
   aws-foo
   aws=2.0.50
   clinst-test-ext
   ```

### List *Extensions*

Want to know what extensions are available?
   ```bash
   $ clinst -L
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
   $ clinst -L terraform | head
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


### Cryptographically verifying signatures

To ensure the **clinst** tool and extensions are genuine and not modified by an attacker,
you can use GPG or other OpenPGP tools to verify the authenticity of the files. These
authenticated files can then be used to authenticate your downloaded/installed programs.

First, install GnuPG (`gpg`).

Second, import the public key used to sign the release files. If you don't know what
public key was used (or are wary of trusting one listed here for fear an attacker might
have replaced the fingerprint ID) you can search for the keys using the e-mail address
of the author:
```
$ gpg --keyserver keyserver.ubuntu.com --search-keys peterwwillis@gmail.com
gpg: data source: http://162.213.33.9:11371
(1)	Peter Willis (mobile key 1) <peterwwillis@gmail.com>
	  4096 bit RSA key CD7E9DBA8044A099, created: 2017-06-07
Keys 1-1 of 1 for "peterwwillis@gmail.com".  Enter number(s), N)ext, or Q)uit > q
gpg: error searching keyserver: Operation cancelled
gpg: keyserver search failed: Operation cancelled
```
Verify that the key fingerprint shown matches the fingerprint used to sign GitHub
commits. Then import the key fingerprint:
```
$ gpg --keyserver keyserver.ubuntu.com --recv-keys CD7E9DBA8044A099
gpg: key CD7E9DBA8044A099: public key "Peter Willis (mobile key 1) <peterwwillis@gmail.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

Now you can manually verify the `*.asc` files were signed by that key:
```
$ for i in *.asc .clext/*.asc ; do gpg --verify $i ; done
```


### Be quiet

To silence the normal output of **clinst**, pass the `-q` option, or set environment
variable `CLINST_QUIET=1`.

---

## Testing

Run `make` in this directory to run all the tests. See [.clext/tests/](./.clext/tests/) for details.

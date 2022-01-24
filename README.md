# clinst

A version-tracking non-packaged-software installer for local/unprivileged users. Inspired by tools like `rbenv`, `tfenv`, and `virtualenv`, but without being dedicated to a single program or programming language.

**clinst** installs software in your local user's home directory (primarily software that has no installer or official package distribution). It also tracks the versions of software and can keep multiple versions of the same software installed simultaneously. You can choose what version of the software to execute, or you can use `.EXTENSION-version` files to execute a different version in different directories.

**clinst** requires an *Extension*, or program-specific instructions, to know how to download and install that program. There are many *Extensions* bundled in this repo. You can contribute *Extensions* to this project, or maintain and use your own.

You can also use **clinst** without *Extensions*, as a sort of environment-managing tool. **clinst** allows you to create directories called *Environments* which are a plain directory with a small shell script that's loaded to set a `$PATH` before running a command.


# Requirements

 - A POSIX shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, grep, etc)
 - `curl`


# Features
 - Use *Extensions* to automate downloading & installing applications (**ansible**, **aws**, **docker-compose**, **eksctl**, **gh**, **helm**, **istioctl**, **kind**, **krew**, **krew**, **kubectl**, **packer**, **saml2aws**, **terraform-docs**, **terraformer**, **terraform**, **terraform_landscape**, **terragrunt**, **tflint**, **tfsec**, **ydiff**, **yq**)
 - Install your own *Extensions* from GitHub (`clinst -E github.com/foo/bar`)
 - Pin versions with `.EXTENSION-version` files
 - Wrappers in your shell to automatically try to install and run supported programs if they're not yet installed
 - Wrappers for each installed program to automatically change or install specific
 - Small codebase, common dependencies
 - Customize environments to your needs

# Quick start

1. Copy+paste the following snippet in your terminal to install **clinst**:
   ```bash
   mkdir -p $HOME/.clinst/.bin && \
   curl -fsSL -o $HOME/.clinst/.bin/clinst https://raw.githubusercontent.com/peterwwillis/clinst/v3.0.0/clinst \
   && chmod +x $HOME/.clinst/.bin/clinst \
   && echo "4e4d436139ac29467139708704a42b308198491364e132e40a4e7f2a8aaa0924  $HOME/.clinst/.bin/clinst" | sha256sum -c \
   || { echo "FAILED CHECKSUM: REMOVING clinst" && sudo rm -f $HOME/.clinst/.bin/clinst ; }
   ```

2. Add the following to your `~/.bashrc` file to add `~/.clinst/.bin` to your
   shell's *PATH*:
   ```bash
   eval "$(~/.clinst/.bin/clinst -s)"
   ```

3. Install a program using **clinst**:

   ```bash
   $ clinst -E packer
   clinst: Downloading extension 'packer'
   clinst: Creating new environment '/home/vagrant/.clinst/packer=1.7.9'
   clinst: Loading extension 'packer' version '1.7.9'
   clinst: packer: Removing temporary download files
   clinst: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.6M  100 30.6M    0     0  12.3M      0  0:00:02  0:00:02 --:--:-- 12.3M
   clinst: packer: Unpacking to '/home/vagrant/.clinst/packer=1.7.9'
   clinst: packer: Installing locally
   clinst: packer: Testing
   clinst: packer: Removing temporary download files
   clinst: packer: Installing wrapper
   ```
   
   Now if you run a command that you've installed with **clinst**, it will be
   automatically run using the wrapper in `~/.clinst/.bin`:
      
   ```bash
   vagrant@devbox:~$ packer --version
   clinst: Executing /home/vagrant/.clinst/packer/bin/packer
   1.7.9
   ```

4. If you use the **bash** shell, you don't even need to run **clinst** to install a program.
   Just call the name of a supported program and it will automatically be installed and run:
   ```bash
   vagrant@devbox:~$ which packer
   vagrant@devbox:~$ packer
   clinst: Downloading extension 'packer'
   clinst: Creating new environment '/home/vagrant/.clinst/packer=1.7.9'
   clinst: Loading extension 'packer' version '1.7.9'
   clinst: packer: Removing temporary download files
   clinst: packer: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 30.6M  100 30.6M    0     0  12.4M      0  0:00:02  0:00:02 --:--:-- 12.4M
   clinst: packer: Unpacking to '/home/vagrant/.clinst/packer=1.7.9'
   clinst: packer: Installing locally
   clinst: packer: Testing
   clinst: packer: Removing temporary download files
   clinst: packer: Installing wrapper
   clinst: Executing /home/vagrant/.clinst/packer=1.7.9/bin/packer
   Usage: packer [--version] [--help] <command> [<args>]
   
   Available commands are:
       build           build image(s) from template
       console         creates a console for testing variable interpolation
       fix             fixes templates from old versions of packer
       fmt             Rewrites HCL2 config files to canonical format
       hcl2_upgrade    transform a JSON template into an HCL2 configuration
       init            Install missing plugins or upgrade plugins
       inspect         see components of a template
       validate        check that a template is valid
       version         Prints the Packer version
   ```

5. Pin the version of the *Extension* in the current directory, so the same
   version of your application is always run:
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

6. To always get the latest *Extensions* (not just the ones that were released
   with your version of **clinst**) use the `main` version of **clinst**:

   ```bash
   export CLINST_VER=main
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
        -X CMD [ARG ..]         (internal function) Run command for an extension
        -W                      Disables wrapper mode
        -s                      Outputs Bourne shell features to include in your ~/.bashrc
        -f                      Force mode
        -V                      Version of clinst
        -q                      Quiet mode
   ```

---

## How it works


### How do I install and run a program?

When you run a command like `clinst CMD`, this happens:

 1. **clinst** looks for an *Environment* with the same name (`$CLINST_DIR/CMD`).
    If found, it will load that *Environment* configuration (`$CLINST_DIR/CMD/.env`).
    Then it will try to run program `CMD`.

 2. If the *Environment* was not found, **clinst** looks for an *Extension* of the
    same name (`$CLINST_HTTP_PATH/.clext/EXTENSION.ex` or `EXTENSION.e`). If found,
    it downloads the  *Extension*, uses it to install `CMD` in an *Environment* of
    the same name, then follows step #1.

 3. If no *Extension* or *Environment* is found, **clinst** dies.
    ```bash
    $ clinst foobar
    clinst: Installing extention 'foobar'
    curl: (22) The requested URL returned error: 404
    ```


### *Environments*

*Environments* are directories with a configuration file, some shell scripts,
and any programs you install.

*Environments* are kept in sub-directories of *$CLINST_DIR* (default: *$HOME/.clinst/*).
Each *Environment* has at least two files:
 - `bin/` : applications (or symlinks to applications) installed here.
 - `.env` : A shell script to set environment variables at run time.

*Environments* are created or modified when a program is installed in one.
You can also create them manually using the `-n` option.

#### Default *Environment*

Every installed version of a program gets its own *Environment*. You can change
the default *Environment* used by the wrapper using the `-D` option.

   ```bash
   vagrant@devbox:~$ terraform --version
   clinst: Executing /home/vagrant/.clinst/terraform=0.11.15/bin/terraform
   Terraform v0.11.15
   vagrant@devbox $ clinst -D terraform=0.12.31
   clinst: Switching default environment for extension terraform to terraform=0.12.31
   clinst: terraform: Installing wrapper
   vagrant@devbox $ terraform --version
   clinst: Executing /home/vagrant/.clinst/terraform=0.12.31/bin/terraform
   Terraform v0.12.31
   ```

#### Manually setting up an *Environment*

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

#### Listing *Environments*

Let's see the *Environments* we've created so far:
   ```bash
   $ clinst -l
   aws
   aws-foo
   aws=2.0.50
   clinst-test-ext
   ```


### *Extensions*

*Extensions* are files that contain instructions for how to download and install
a program. They're like the build instructions used by package managers to build
and package software.

#### Different kinds of *Extensions*

There are two kinds of *Extensions*:
 - **Stub extension:** A set of key=value pairs that are `eval`ed by the running
   shell and set configuration information.
 - **Executable extension:** An executable program that takes command-line inputs
   and returns output. Each function of **clinst** can be written as a dedicated
   command of this executable, so that you can implement any stage of the process
   using any kind of executable (write them in any program language, basically).

#### *Extension* Wrappers

*Extensions* install a wrapper for your program in a common directory
(`$HOME/.clinst/.bin/`) that you can add to your shell's `$PATH`. This wrapper
points at a specific version of your program, so this is how the default version
to run is set. However, if you have a `.EXTENSION-version` file in your current
directory (or any parent directory), **clinst** will automatically download,
install, and run that version of the program instead of the default one.

#### Using *Extensions*

**clinst** will download *Extensions* with `curl` from a URL
(`$CLINST_HTTP_PATH/.clext/EXTENSION.ex` or `EXTENSION.e`). Override 
*$CLINST_HTTP_PATH* if you want to provide your own *Extension* path or URL.

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


#### Version pinning with `.EXTENSION-version` files

If a file `.EXTENSION-version` exists in the current or a parent directory, the
contents of the file becomes the version of an *Extension* to install. If you
specify a version in the `-E` option, this does not happen, and the `-W` option
disables it entirely. The name `EXTENSION` should be the name of the program
you're running; if you're running `terraform`, the file name will be
`.terraform-version`. (Technically, `EXTENSION` should actually be the name of
the installed *Extension*, not the command you're running)

Some *Extensions* may install multiple commands, but **clinst** will not create
wrappers for all of them. If the *Extension* installs multiple commands into
the *Environment*, you will need to run **clinst** and specify the *Environment*
to use, along with the command to run. For example:

   ```bash
   vagrant@devbox:~$ clinst -e ansible=4.2.0 ansible-playbook
   ```

(Don't see an *Extension* you want? Check out the [.clext/](./.clext/) directory,
cut me a Pull Request, I'll merge it! Or create your own via a GitHub repository)

#### List available *Extensions*

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

**NOTE: This feature is still in testing; consider it non-functional!**

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

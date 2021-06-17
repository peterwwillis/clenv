# About

**clenv** is a shell script that lets you manage and run multiple versions of a program. (Think of it like *virtualenv*, *rbenv*, *tfenv*, etc, but for any program)


# Requirements

 - A POSIX-ish shell
 - Standard Unixy tools (mkdir, env, chmod, basename, etc)
 - Optional: Curl


# How it works

**clenv** keeps a directory *$CLENV_DIR* (default: *$HOME/.clenv/*). In that
directory are sub-directories called *Environment*s.

Each *Environment* directory has at least two files:
 - `bin/` : Put programs you want to execute in here.
 - `.env` : A shell script loaded into the shell to set environment variables. 

When **clenv** is run with *Environment* and `CMD` arguments, it loads the
*Environment*'s `.env` shell script, sets the environment variable *$PATH* to
include the *Environment*'s `bin/` directory, and then runs `CMD` (which lives
in the `bin/` directory).

This allows you to keep different versions of programs in different
*environment*s and execute those specific versions using **clenv**.

## Features

 - **clenv** has *Extensions*. They are optional scripts that can download and
   install particular programs for you. This way you don't have to manually set
   up your *Environment* directories with different versions of programs; the
   extensions do it for you.

   If an extension doesn't exist for the program you want to install 

 - **clenv** has a special wrapper mode. When an *Extension* is installed, a
   matching script is created in `$CLENV_DIR/.bin/`. This wrapper can then
   detect if you have a '.$extension-version' file in your current directory,
   and automatically install and run that version of that extension's software.
   Add the `$CLENV_DIR/.bin/` directory to your *$PATH* to use the wrappers.


# Getting started

1. Run **clenv** to get the options.
   ```bash
    Usage: ./clenv [OPTS]
           ./clenv [OPTS] [ENVIRON [CMD [ARGS ..]] ]
    Opts:
        -h			This screen
        -i			Clear environment variables. Must be first argument
        -l [ENVIRON]		List versions
        -n ENVIRON		Create a new ENVIRON
        -I EXT[=V] [ENVIRON] 	Install version V of extension EXT into ENVIRON
        -W EXT [-- CMD ..]	Installs extension EXT and runs CMD
        -f			Force mode
        -V          Version of clenv
   ```

2. Create a new *Environment* directory. (Example name: `aws2050`)
   ```bash
   $ ./clenv -n aws2050
   ```

3. Install a program in the new directory. You can do this two ways:
   1. Manually copy a program into `~/.clenv/aws2050/bin/`.
   2. Use a **clenv extension** to install a specific version of a program.
      ```bash
      $ ./clenv -I aws-cli-v2=2.0.50 aws2050
      ./clenv: Loading extention aws-cli-v2 version 2.0.50
      /home/vagrant/.clenv/.ext/aws-cli-v2: Loading extension version '2.0.50'
      /home/vagrant/.clenv/.ext/aws-cli-v2: Removing awsclenv2.zip
      /home/vagrant/.clenv/.ext/aws-cli-v2: Downloading awsclenv2.zip
        % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                       Dload  Upload   Total   Spent    Left  Speed
      100 32.2M  100 32.2M    0     0  13.4M      0  0:00:02  0:00:02 --:--:-- 13.4M
      /home/vagrant/.clenv/.ext/aws-cli-v2: Unpacking aws to '/home/vagrant/.clenv/aws2050/usr'
      /home/vagrant/.clenv/.ext/aws-cli-v2: Installing symlink: /home/vagrant/.clenv/aws2050/usr/aws/dist/aws -> bin/aws
      /home/vagrant/.clenv/.ext/aws-cli-v2: Testing aws
      aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
      /home/vagrant/.clenv/.ext/aws-cli-v2: Removing awsclenv2.zip
      ```

4. Run the program.
   ```bash
   ./clenv aws2050 aws --version
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

# Using the default bin directory

You can install default verisons of programs with **clenv** and still use a `.EXTENSION-version` file in any directory.

1. Install the default version using an extension. Example:
   ```bash
   clenv -I terraform=0.12.31
   clenv: Loading extension version '0.12.31'
   clenv: Removing download
   clenv: Downloading
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
     100 27.1M  100 27.1M    0     0  4452k      0  0:00:06  0:00:06 --:--:-- 4792k
   clenv: Unpacking terraform to '/home/vagrant/.clenv/terraform'
   clenv: Installing symlink
   clenv: Testing terraform
   Terraform v0.12.31
   clenv: Removing download
   ```
2. In a new directory, create a `.EXTENSION-version` file with the version you want to use.
   ```bash
   $ mkdir foo
   $ cd foo
   $ echo "0.15.3" > .terraform-version
   $ cd ..
   ```
3. Export your PATH to include `~/.clenv/.bin/` first (note you need both '.')
   ```bash
   $ export PATH=~/.clenv/.bin:$PATH
   ```
4. Check the version in different directories.
   ```bash
   $ terraform --version
   Terraform v0.12.31
   $ cd foo
   $ terraform --version
   clenv: Loading extension version '0.15.3'
   clenv: Removing download
   clenv: Downloading
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 31.2M  100 31.2M    0     0  4459k      0  0:00:07  0:00:07 --:--:-- 5837k
   clenv: Unpacking terraform to '/home/vagrant/.clenv/terraform=0.15.3'
   clenv: Installing symlink
   clenv: Testing terraform

   Terraform v0.15.3
   on linux_amd64
   clenv: Removing download
   Terraform v0.15.3
   on linux_amd64
   ```

# Extensions

Extensions are optional helper programs that download and install any version of
a program that you might want. They are shell scripts that take a command-line
argument, and check certain environment variables.

Extensions assume they are running in an *Environment* directory. They will change to
a `$CLENV_DIR/$CV_NAME` directory first if those environment variables are set.

Check the [.ext/](./.ext/) directory for the available extensions.


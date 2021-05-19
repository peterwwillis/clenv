# About

**cliv** is a shell script that lets you manage and run multiple versions of a program. (Think of it like *virtualenv*, *rbenv*, *tfenv*, etc, but for any program)


# Requirements

 - A POSIX-ish shell
 - Standard Unixy tools (mkdir, env, chmod, basename, etc)
 - Optional: Curl


# How it works

**cliv** keeps a directory *$CLIV_DIR* (default: *$HOME/.cliv/*). In that directory
are sub-directories, called `ALIAS`es.

Each `ALIAS` directory has at least two files:
 - `bin/` : Put programs you want to execute in here.
 - `.env` : A shell script loaded into the shell to set environment variables. 

When **cliv** is run with an ALIAS and CMD, it loads the `.env` file, sets the
`PATH` to include the `bin/` directory, and then runs `CMD`, which lives in the
`bin/` directory.

This way you can keep multiple versions of the same program in different `ALIAS`
directories, and call them individually using **cliv**.

## Features

 - **cliv** has *Extensions*, which are basically mini scripts that can download and install particular programs for you. This way you don't have to manually set up your `ALIAS` directories with different versions of programs; the extensions do it for you.

 - **cliv** has a special wrapper mode. When an *Extension* is installed, a matching script is created in `$CLIV_DIR/.bin/`. This wrapper can then detect if you have a '.$extension-version' file in your current directory, and automatically install and run that version of that extension's software.


# Getting started

1. Run **cliv** to get the options.
   ```bash
    Usage: ./cliv [OPTS]
           ./cliv [OPTS] [ALIAS [CMD [ARGS ..]] ]
    Opts:
        -h			This screen
        -i			Clear environment variables. Must be first argument
        -l [ALIAS]		List versions
        -n ALIAS		Create a new ALIAS
        -I EXT[=V] [ALIAS] 	Install version V of extension EXT into ALIAS
        -W EXT [-- CMD ..]	Installs extension EXT and runs CMD
        -f			Force mode
   ```

2. Create a new `ALIAS` directory. (Example name: `aws2050`)
   ```bash
   $ ./cliv -n aws2050
   ```

3. Install a program in the new directory. You can do this two ways:
   1. Manually copy a program into `~/.cliv/aws2050/bin/`.
   2. Use a **cliv extension** to install a specific version of a program.
      ```bash
      $ ./cliv -I aws-cli-v2=2.0.50 aws2050
      ./cliv: Loading extention aws-cli-v2 version 2.0.50
      /home/vagrant/.cliv/.ext/aws-cli-v2: Loading extension version '2.0.50'
      /home/vagrant/.cliv/.ext/aws-cli-v2: Removing awscliv2.zip
      /home/vagrant/.cliv/.ext/aws-cli-v2: Downloading awscliv2.zip
        % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                       Dload  Upload   Total   Spent    Left  Speed
      100 32.2M  100 32.2M    0     0  13.4M      0  0:00:02  0:00:02 --:--:-- 13.4M
      /home/vagrant/.cliv/.ext/aws-cli-v2: Unpacking aws to '/home/vagrant/.cliv/aws2050/usr'
      /home/vagrant/.cliv/.ext/aws-cli-v2: Installing symlink: /home/vagrant/.cliv/aws2050/usr/aws/dist/aws -> bin/aws
      /home/vagrant/.cliv/.ext/aws-cli-v2: Testing aws
      aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
      /home/vagrant/.cliv/.ext/aws-cli-v2: Removing awscliv2.zip
      ```

4. Run the program.
   ```bash
   ./cliv aws2050 aws --version
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

# Using the default bin directory

You can install default verisons of programs with **cliv** and still use a `.EXTENSION-version` file in any directory.

1. Install the default version using an extension. Example:
   ```bash
   cliv -I terraform=0.12.31
   cliv: Loading extension version '0.12.31'
   cliv: Removing download
   cliv: Downloading
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
     100 27.1M  100 27.1M    0     0  4452k      0  0:00:06  0:00:06 --:--:-- 4792k
   cliv: Unpacking terraform to '/home/vagrant/.cliv/terraform'
   cliv: Installing symlink
   cliv: Testing terraform
   Terraform v0.12.31
   cliv: Removing download
   ```
2. In a new directory, create a `.EXTENSION-version` file with the version you want to use.
   ```bash
   $ mkdir foo
   $ cd foo
   $ echo "0.15.3" > .terraform-version
   $ cd ..
   ```
3. Export your PATH to include `~/.cliv/.bin/` first (note you need both '.')
   ```bash
   $ export PATH=~/.cliv/.bin:$PATH
   ```
4. Check the version in different directories.
   ```bash
   $ terraform --version
   Terraform v0.12.31
   $ cd foo
   $ terraform --version
   cliv: Loading extension version '0.15.3'
   cliv: Removing download
   cliv: Downloading
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 31.2M  100 31.2M    0     0  4459k      0  0:00:07  0:00:07 --:--:-- 5837k
   cliv: Unpacking terraform to '/home/vagrant/.cliv/terraform=0.15.3'
   cliv: Installing symlink
   cliv: Testing terraform

   Terraform v0.15.3
   on linux_amd64
   cliv: Removing download
   Terraform v0.15.3
   on linux_amd64
   ```

# Extensions

Extensions are optional helper programs that download and install any version of
a program that you might want. They are shell scripts that take a command-line
argument, and check certain environment variables.

Extensions assume they are running in an ALIAS directory. They will change to
a `$CLIV_DIR/$CV_NAME` directory first if those environment variables are set.

Check the [.ext/](./.ext/) directory for the available extensions.


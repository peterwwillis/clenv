# About

**cliv** is a shell script that lets you manage and run multiple versions of programs.


# Requirements

 - A POSIX-ish shell
 - Standard Unixy tools (mkdir, env, chmod, basename, etc)
 - Optional: Curl


# How it works

**cliv** keeps a directory *$CLIV_DIR* (default: *$HOME/.cliv/*). Each subdirectory there is a "version directory".

Each "version directory" has at least two files. (You can do anything you want in these directories, **cliv** won't care)
 - `bin/` : Put programs you want to execute in here.
 - `.env` : This file is loaded into the shell to set environment variables. The `PATH` environment variable is set to your current PATH plus the `bin/` directory when this "version directory" is initially created. You can do anything you want with it after that.

You run **cliv** giving it the name of a "version directory" and some arguments to execute. Then **cliv** loads the `.env` file and executes your arguments.

That's it.


# Getting started

1. Run **cliv** to get the options.
   ```bash
   $ ./cliv
   Usage: ./cliv [OPTS]
          ./cliv [OPTS] VERSION [CMD [ARGS ..]]
   Opts:
           -h              This screen
           -i              Clear environment variables. Must be first argument
           -l [VERSION]    List versions
           -n              Create a new /home/vagrant/.cliv/VERSION
           -I EXT[=V]      Install version V of extension EXT into VERSION
   ```

2. Create a new `VERSION` directory. (Example name: `aws2050`)
   ```bash
   $ ./cliv -n aws2050 echo success
   success
   $ 
   ```

3. Install a program in the new directory. You can do this two ways:
   1. Manually install a program in `~/.cliv/aws2050/bin/`.
   2. Use a **cliv extension** to install a specific version of a program.
      ```bash
      $ ./cliv -I aws-cli-v2=2.0.50 aws2050 echo success
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
      success
      ```

4. Run the program.
   ```bash
   ./cliv aws2050 aws --version
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```

If you want, you can do all those steps at once (ex. `./cliv -n -I aws-cli-v2=2.0.50 aws2050 echo success`).


# Extensions

Extensions are completely optional helper programs that download and install any version of a program that you might want. They're just shell scripts that take one or two arguments, and assume they are running in a "version directory". You can write your own extensions and contribute them here, or fork this repo and maintain your own.

Check the [.ext/](./.ext/) directory for the available extensions.

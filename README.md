# About

**clenv** is a shell script that lets you manage and run multiple versions of a program. (Think of it like *virtualenv*, *rbenv*, *tfenv*, etc, but for any program)


# Requirements

 - A POSIX-ish shell
 - Standard Unix-y tools (mkdir, env, chmod, basename, etc)
 - `curl` or `wget` if you want to install *Extensions*

---

# Quick start

## Install clenv
```bash
$ sudo curl -fsSL -o /usr/local/bin/clenv https://raw.githubusercontent.com/peterwwillis/clenv/v1.3.0/clenv \
  && sudo chmod +x /usr/local/bin/clenv \
  && echo "00854335a8e649513a47507e7108f0facc2fee35667f0f0a99425e0f57fb4ef9  /usr/local/bin/clenv" | sha256sum -c \
  || { echo "FAILED CHECKSUM: REMOVING clenv" && sudo rm -f /usr/local/bin/clenv ; }
/usr/local/bin/clenv: OK
```

## Install a program with an extension
```bash
$ clenv -I packer
/usr/local/bin/clenv -I packer
clenv: Installing extention packer
clenv: packer: Installing wrapper
clenv: Loading packer version '1.7.3'
clenv: packer: Removing temporary download files
clenv: packer: Downloading artifact
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 30.2M  100 30.2M    0     0  8829k      0  0:00:03  0:00:03 --:--:-- 8826k
clenv: packer: Unpacking to '/home/vagrant/.clenv/packer'
clenv: packer: Installing symlink
clenv: packer: Testing
1.7.3
clenv: packer: Removing temporary download files
clenv:
$ ~/.clenv/.bin/packer --version
clenv: Looking for '/home/vagrant/git/PUBLIC/clenv/.packer-version
clenv: Looking for '/home/vagrant/git/PUBLIC/.packer-version
clenv: Looking for '/home/vagrant/git/.packer-version
clenv: Looking for '/home/vagrant/.packer-version
clenv: Executing /home/vagrant/.clenv/packer/bin/packer
1.7.3
```

---

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
*Environment*s and execute those specific versions using **clenv**.

Run **clenv** to check out all the options:
   ```bash
   $ clenv
    Usage: clenv [OPTS]
           clenv [OPTS] [ENVIRON [CMD [ARGS ..]] ]
    Opts:
        -h                      This screen
        -i                      Clear environment variables. Must be first argument
        -l [ENVIRON]            List versions
        -n ENVIRON              Create a new ENVIRON
        -I EXT[=V] [ENVIRON]    Install version V of extension EXT into ENVIRON
        -W EXT [-- CMD ..]      Installs extension EXT and runs CMD
        -f                      Force mode
        -V                      Version of clenv
   ```

## Features

### Extensions

*Extensions* are optional helper programs that download and install specific
versions of programs into *Environment*s for you. `clenv` comes with a bunch
of *Extensions*, and you can provide your own too.

Available extensions:
 - **aws-cli**
 - **docker-compose**
 - **packer**
 - **saml2aws**
 - **terraform**
 - **terraformer**
 - **yq**

`clenv` will look for extensions with `curl` or `wget` from a URL
`$CLENV_HTTP_PATH/.ext/EXTENSION`. Override the *$CLENV_HTTP_PATH* if you want
to provide your own *Extension* path or URL.

You can also put extensions directly into your `~/.clenv/.ext/` directory.

(Don't see an extension you want? Check out the [.ext/](./.ext/) directory,
cut me a Pull Request, I'll merge it!)

### Wrappers 

When an *Extension* is installed, it creates a wrapper script in `$CLENV_DIR/.bin/`
named after the program you installed. This wrapper will tell `clenv` how to run
your program so you don't have to use the `clenv` command.

The wrapper mode will also look for a file `.EXTENSION-version` in the current
directory (and parent directories). If it finds that file, the contents of that
file is the version of the *Extension* that `clenv` will install and use to run
your program.

So just add the `$CLENV_DIR/.bin/` directory to your *$PATH*, install a program
using an *Extension*, and then just run your program. `clenv` will detect the
correct version of your program to use, install it if needed, load the
*Environment*, and execute your program.


---

# Usage


## Manual set-up

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
   $ clenv aws aws --version
   clenv: Executing /home/vagrant/.clenv/aws/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   ```


## Using Extensions

You can install a specific version of an *Extension* into a **default** *Environment*:

   ```bash
   $ clenv -I aws-cli=2.0.50
   clenv: Loading aws-cli version '2.0.50'
   clenv: aws-cli: Removing temporary download files
   clenv: aws-cli: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 32.2M  100 32.2M    0     0  8806k      0  0:00:03  0:00:03 --:--:-- 8803k
   clenv: aws-cli: Unpacking to '/home/vagrant/.clenv/aws-cli'
   clenv: aws-cli: Installing symlink
   clenv: aws-cli: Testing
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   clenv: aws-cli: Removing temporary download files
   clenv:
   ```

Or you can create a **version-specific** *Environment* (note the final argument to `clenv` below - that's the *Environment* name).
This is what happens in the background when you use a `.EXTENSION-version` file.

   ```bash
   $ clenv -I aws-cli=2.0.50 aws-cli=2.0.50
   clenv: Loading aws-cli version '2.0.50'
   clenv: aws-cli: Removing temporary download files
   clenv: aws-cli: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 32.2M  100 32.2M    0     0  9908k      0  0:00:03  0:00:03 --:--:-- 9905k
   clenv: aws-cli: Unpacking to '/home/vagrant/.clenv/aws-cli=2.0.50'
   clenv: aws-cli: Installing symlink
   clenv: aws-cli: Testing
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   clenv: aws-cli: Removing temporary download files
   clenv:
   ```

## List environments

Let's see the *Environment*s we've created so far:
   ```bash
   $ clenv -l
   aws
   aws-cli
   aws-cli=2.0.50
   ```

## Version-pinned environments

Finally: this is probably why you want to use this program! You can use a 
`.EXTENSION-version` file to specify a specific version of an *Extension* to
install depending on what directory you're running `clenv` in.

1. In a new directory, create a `.EXTENSION-version` file with the version you want to use.
   ```bash
   $ mkdir foo
   $ cd foo
   $ echo "2.2.10" > .aws-cli-version
   $ cd ..
   ```
2. Export your PATH to include `~/.clenv/.bin/` (that is `/.bin/`, not `/bin/`)
   ```bash
   $ export PATH=~/.clenv/.bin:$PATH
   ```
3. Check the version of your program in different directories. The wrapper will
   automatically install the proper extension version as needed.
   ```bash
   $ pwd
   /home/vagrant/git/PUBLIC/clenv/.ext
   $ aws --version
   clenv: Looking for '/home/vagrant/git/PUBLIC/clenv/.ext/.aws-cli-version
   clenv: Looking for '/home/vagrant/git/PUBLIC/clenv/.aws-cli-version
   clenv: Looking for '/home/vagrant/git/PUBLIC/.aws-cli-version
   clenv: Looking for '/home/vagrant/git/.aws-cli-version
   clenv: Looking for '/home/vagrant/.aws-cli-version
   clenv: Executing /home/vagrant/.clenv/aws-cli/bin/aws
   aws-cli/2.0.50 Python/3.7.3 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18
   $ cd foo
   $ aws --version
   clenv: Looking for '/home/vagrant/git/PUBLIC/clenv/.ext/foo/.aws-cli-version
   clenv: Found '/home/vagrant/git/PUBLIC/clenv/.ext/foo/.aws-cli-version' = '2.2.10'
   clenv: Loading aws-cli version '2.2.10'
   clenv: aws-cli: Removing temporary download files
   clenv: aws-cli: Downloading artifact
     % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
   100 41.6M  100 41.6M    0     0  10.2M      0  0:00:04  0:00:04 --:--:-- 10.2M
   clenv: aws-cli: Unpacking to '/home/vagrant/.clenv/aws-cli=2.2.10'
   clenv: aws-cli: Installing symlink
   clenv: aws-cli: Testing
   aws-cli/2.2.10 Python/3.8.8 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18 prompt/off
   clenv: aws-cli: Removing temporary download files
   clenv:
   clenv: Executing /home/vagrant/.clenv/aws-cli=2.2.10/bin/aws
   aws-cli/2.2.10 Python/3.8.8 Linux/4.15.0-135-generic exe/x86_64.ubuntu.18 prompt/off
   ```

As you can see, `clenv` will look for the `.EXTENSION-version` file starting from
the current directory, and work its way back up each parent directory up to your
home directory.


You technically don't need to use an *Extension* to take advantage of this feature.
It is enabled by the 'wrapper' argument to `clenv`. You can set up an
*Environment* manually and create a script to call `clenv` like this:
   ```bash
   #!/usr/bin/env sh
   # this will make clenv look for .EXTENSION-version files.
   # optionally export CLENV_E_VERSION to avoid the .EXTENSION-version check
   exec clenv -W <EXTENSION> <ENVIRONMENT> <COMMAND> [<ARGUMENTS>]
   ```

---

# Testing

## Extensions
Run `make` in this directory to test all the *Extensions*. See [.ext/tests/](./.ext/tests/) for details.

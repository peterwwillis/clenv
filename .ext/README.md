# About

This directory contains the *Extensions* for `clenv`. They are currently
implemented as shell scripts, but any executable file can be an *Extension*.

Each takes environment variables and command-line arguments, and is fully 
responsible for installing and running programs in an *Environment*.

Extensions assume they are running in an *Environment* directory. They will change to
a `$CLENV_DIR/$CV_NAME` directory first if those environment variables are set.

---

## Environment Variables

The following environment variables are passed by `clenv` to *Extensions*:
 - **CLENV_DIR:** The directory which contains the user's `clenv` install files (default: `$HOME/.clenv/`)
 - **CLENV_E_ENVIRON:** The *Environment* that the program's files will be installed into.
 - **CLENV_E_INSTDIR:** The path into which the program's files should be installed. `clenv` passes this as `$HOME/.clenv/$CLENV_E_ENVIRON`.

The following environment variables are commonly (but not necessarily) overrideable within an *Extension*:
 - **CLENV_E_INSTDIR:** If this was not passed by `clenv`, defaults to the current directory.
 - **CLENV_E_NAME:** The name of the extension. This is commonly - but not necessarily - the same name as the program it installs.
 - **CLENV_E_REV:** The revision (version) of the extension. Different than the version of the program it installs.
 - **CLENV_E_OS:** (optional) The name of an operating system. Only used to specify what file to download, if the program has OS-specific downloads.
 - **CLENV_E_ARCH:** (optional) The name of a CPU architecture. Only used to specify what file to download, if the program has Archtecture-specific downloads.

## Commands

Each *Extension* takes command-line arguments. The following commands MUST be supported by an extension in order to be run by `clenv`:
 - **clean**
 - **download**
 - **unpack**
 - **install-local**
 - **test**
 - **install-wrapper**

---

# Testing

## Shellcheck
You can run `shellcheck` on the extensions in this directory (assuming all the extensions are shell scripts).
```bash
make shellcheck
```

## Local testing
Use this method to manually test an extension in the current Git working directory.
Example: 
```bash
clenv -l aws2050 || ../clenv -n aws2050
DEBUG=1 CLENV_HTTP_PATH=file://`pwd`/.. clenv -I aws-cli-v2=2.0.50 aws2050
```

# About

This directory contains the *Extensions* for `clenv`. They have file extension 
'.ex'.

They are currently implemented as shell scripts, but any executable file can be
an *Extension*. Each *Extension* takes environment variables and command-line 
arguments and is called by **clenv**.

*Extensions* can provide their own functions to perform each of the steps of
downloading, installing, and running programs. However, since most *Extensions*
perform nearly-identical functions, **clenv** has its own default functions
to run if the *Extension* doesn't provide them. This allows the *Extension* to
implement a bare-minimum of functionality (making it easier to make new *Extensions*).

**clenv** will run the *Extension* with a `help` command, and the output of that
command tells **clenv** what functions the *Extension* provides. The *Extension* 
must also provide a `variables` command to be used with the **clenv** internal
functions.

The *Extension* should export variables as environment variables if it calls
**clenv** with the `-X` option. The `-X` option calls **clenv** functions that
start with `_ext_` (and optionally passes arguments to the function). It's not
unusual for **clenv** to call an *Extension*, for the *Extension* to then call
**clenv**, and for **clenv** to again call the *Extension*.

Extensions assume they are running in an *Environment* directory. They will 
change to a `$CLENV_E_INSTDIR` directory (default: `$CLENV_DIR/$CLENV_E_ENVIRON`)
first if those environment variables are set.

---

## Environment Variables

The following environment variables are passed by `clenv` to *Extensions*:
 - **CLENV_DIR:** The directory which contains the user's `clenv` install files (default: `$HOME/.clenv/`)
 - **CLENV_E_NAME:** The name of the *Extension*.
 - **CLENV_E_ENVIRON:** The *Environment* that the program's files will be installed into.
 - **CLENV_E_INSTDIR:** The path into which the program's files should be installed. `clenv` passes this as `$HOME/.clenv/$CLENV_E_ENVIRON`.
 - **CLENV_E_VERSION:** The version of the program to install.

The following environment variables are defined by *Extensions*:
 - **CLENV_E_REV:** The revision (version) of the extension. Different than the version of the program it installs.
 - **CLENV_E_BIN_NAME:** The name of the 'binary' (or whatever program) is being installed by the *Extension*. Used by various functions, basically to install wrappers and install files and such. If an extension is installing more than one program into the *Environment*, the *Extension* will probably need to implement its own internal functions (not using the **clenv** internal ones), and this variable wouldn't be used.
 - **CLENV_E_DLFILE:** The file name of the file downloaded by the *Extension*. In practice it doesn't really matter what the value is, but the *Extension* controls it just in case. If the extension isn't downloading a file (say, when installing Python modules with `pip`) this isn't used.
 - **CLENV_E_OS:** (optional) The name of an operating system. Only used to specify what file to download, if the program has OS-specific downloads.
 - **CLENV_E_ARCH:** (optional) The name of a CPU architecture. Only used to specify what file to download, if the program has Archtecture-specific downloads.
 - **CLENV_E_BASEURL:** (optional) The URL used to download artifacts, if downloading them with `curl`. Typically a `printf`-statement to be used with **CLENV_E_BASEURL_ARGS**.
 - **CLENV_E_BASEURL_ARGS:** (optional) Arguments to pass to **CLENV_E_BASEURL** when creating the url to download an artifact. Can have variables which will be interpolated at run-time.

Extensions may define other variables as well but it won't matter to **clenv**.

---

## Commands

Each *Extension* takes command-line arguments. Each extension may implement their own version of the command and provide the name of the command as part of a "help" command. If the extension doesn't list the command in its "help" output, **clenv** will try to use its own general-purpose function instead.

The following commands **MUST** be available in the *Extension*:
 - **help**
 - **variables**
 - **versions**

The following commands **MAY** be available in the *Extension* (they are called at *Extension* install time from **clenv**):
 - **clean**
 - **download**
 - **unpack**
 - **url**
 - **latest**
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
DEBUG=1 CLENV_HTTP_PATH=file://`pwd`/.. clenv -E aws-cli-v2=2.0.50 -e aws2050 aws
```

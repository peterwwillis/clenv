# About

This directory contains the *Extensions* for `cliv`. They have file extension 
'.ex'.

They are currently implemented as shell scripts, but any executable file can be
an *Extension*. Each *Extension* takes environment variables and command-line 
arguments and is called by **cliv**.

*Extensions* can provide their own functions to perform each of the steps of
downloading, installing, and running programs. However, since most *Extensions*
perform nearly-identical functions, **cliv** has its own default functions
to run if the *Extension* doesn't provide them. This allows the *Extension* to
implement a bare-minimum of functionality (making it easier to make new *Extensions*).

**cliv** will run the *Extension* with a `help` command, and the output of that
command tells **cliv** what functions the *Extension* provides. The *Extension* 
must also provide a `variables` command to be used with the **cliv** internal
functions.

The *Extension* should export variables as environment variables if it calls
**cliv** with the `-X` option. The `-X` option calls **cliv** functions that
start with `_ext_` (and optionally passes arguments to the function). It's not
unusual for **cliv** to call an *Extension*, for the *Extension* to then call
**cliv**, and for **cliv** to again call the *Extension*.

Extensions assume they are running in an *Environment* directory. They will 
change to a `$CLIV_E_INSTDIR` directory (default: `$CLIV_DIR/$CLIV_E_ENVIRON`)
first if those environment variables are set.

**New in cliv 2.4.0:** You can create your own GitHub repository to host your
*Extension* and pass the repo to **cliv** to install (`cliv -E github.com/someuser/somerepo`).
Your extension should be named the same as your repository, exist in a folder 
`.ext/`, and have a file extension `.ex`. The *CLIV_E_NAME* variable should stay
the same as the repo and extension name, but you can change the *CLIV_E_BIN_NAME*
variable so that the installed binary/wrapper has a different name. See
https://github.com/peterwwillis/cliv-test-ext/ for an example. You can specify
the Git branch or tag to use by putting `@BRANCH` before any `=VERSION` in the
extension name (`cliv -E github.com/someuser/somerepo@v2.4.0=1.2.3` will install
version 1.2.3 of the *Extension*'s application after downloading the *Extension*
from Git branch/tag *v2.4.0*).

---

## Environment Variables

Passed from `cliv` to *Extensions*:

| Name | Description |
  --- | ---
| **CLIV_DIR**         | The directory which contains the user's `cliv` install files (default: `$HOME/.cliv/`) |
| **CLIV_E_NAME**      | The name of the *Extension*. |
| **CLIV_E_ENVIRON**   | The *Environment* that the program's files will be installed into. The default is `$CLIV_E_NAME=$CLIV_E_VERSION`, but this can be overridden and set to any arbitrary string. |
| **CLIV_E_INSTDIR**   | The path into which the program's files should be installed. `cliv` passes this as `$HOME/.cliv/$CLIV_E_ENVIRON`. |
| **CLIV_E_VERSION**   | The version of the program to install. |

Defined by *Extensions*:

| Name | Description |
  --- | ---
| **CLIV_E_REV**       | The revision (version) of the extension. Different than the version of the program it installs. |
| **CLIV_E_BIN_NAME**  | The name of the 'binary' (or whatever program) is being installed by the *Extension*. Used by various functions, basically to install wrappers and install files and such. If an extension is installing more than one program into the *Environment*, the *Extension* will probably need to implement its own internal functions (not using the **cliv** internal ones), and this variable wouldn't be used. |
| **CLIV_E_DLFILE**    | The file name of the file downloaded by the *Extension*. In practice it doesn't really matter what the value is, but the *Extension* controls it just in case. If the extension isn't downloading a file (say, when installing Python modules with `pip`) this isn't used. |
| **CLIV_E_OS**        | (optional) The name of an operating system. Only used to specify what file to download, if the program has OS-specific downloads. |
| **CLIV_E_ARCH**      | (optional) The name of a CPU architecture. Only used to specify what file to download, if the program has Archtecture-specific downloads. |
| **CLIV_E_BASEURL**   | (optional) The URL used to download artifacts, if downloading them with `curl`. Typically a `printf`-statement to be used with **CLIV_E_BASEURL_ARGS**. |
| **CLIV_E_BASEURL_ARGS** | (optional) Arguments to pass to **CLIV_E_BASEURL** when creating the url to download an artifact. Can have variables which will be interpolated at run-time. |

---

## Commands

Each *Extension* takes command-line arguments. Each extension may implement their own version of the command and provide the name of the command as part of a "help" command. If the extension doesn't list the command in its "help" output, **cliv** will try to use its own general-purpose function instead.

The following commands **MUST** be available in the *Extension*:
 - **help**
 - **variables**
 - **versions**

The following commands **MAY** be available in the *Extension* (they are called at *Extension* install time from **cliv**):
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
```bash
DEBUG=1 CLIV_HTTP_PATH=file://`pwd`/.. cliv -E aws=2.0.50 -e aws2050 aws
```

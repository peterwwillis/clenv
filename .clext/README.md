# About

This directory contains the *Extensions* for `clinst`. They have file extension 
'.ex'.

They are currently implemented as shell scripts, but any executable file can be
an *Extension*. Each *Extension* takes environment variables and command-line 
arguments and is called by **clinst**.

*Extensions* can provide their own functions to perform each of the steps of
downloading, installing, and running programs. However, since most *Extensions*
perform nearly-identical functions, **clinst** has its own default functions
to run if the *Extension* doesn't provide them. This allows the *Extension* to
implement a bare-minimum of functionality (making it easier to make new *Extensions*).

**clinst** will run the *Extension* with a `help` command, and the output of that
command tells **clinst** what functions the *Extension* provides. The *Extension* 
must also provide a `variables` command to be used with the **clinst** internal
functions.

The *Extension* should export variables as environment variables if it calls
**clinst** with the `-X` option. The `-X` option calls **clinst** functions that
start with `_ext_` (and optionally passes arguments to the function). It's not
unusual for **clinst** to call an *Extension*, for the *Extension* to then call
**clinst**, and for **clinst** to again call the *Extension*.

Extensions assume they are running in an *Environment* directory. They will 
change to a `$CLINST_E_INSTDIR` directory (default: `$CLINST_DIR/$CLINST_E_ENVIRON`)
first if those environment variables are set.

**New in clinst 2.4.0:** You can create your own GitHub repository to host your
*Extension* and pass the repo to **clinst** to install (`clinst -E github.com/someuser/somerepo`).
Your extension should be named the same as your repository, exist in a folder 
`.clext/`, and have a file extension `.ex`. The *CLINST_E_NAME* variable should stay
the same as the repo and extension name, but you can change the *CLINST_E_BIN_NAME*
variable so that the installed binary/wrapper has a different name. See
https://github.com/peterwwillis/clinst-test-ext/ for an example. You can specify
the Git branch or tag to use by putting `@BRANCH` before any `=VERSION` in the
extension name (`clinst -E github.com/someuser/somerepo@v2.4.0=1.2.3` will install
version 1.2.3 of the *Extension*'s application after downloading the *Extension*
from Git branch/tag *v2.4.0*).

---

## Environment Variables

Passed from `clinst` to *Extensions*:

| Name | Description |
  --- | ---
| **CLINST_DIR**         | The directory which contains the user's `clinst` install files (default: `$HOME/.clinst/`) |
| **CLINST_E_NAME**      | The name of the *Extension*. |
| **CLINST_E_ENVIRON**   | The *Environment* that the program's files will be installed into. The default is `$CLINST_E_NAME=$CLINST_E_VERSION`, but this can be overridden and set to any arbitrary string. |
| **CLINST_E_INSTDIR**   | The path into which the program's files should be installed. `clinst` passes this as `$HOME/.clinst/$CLINST_E_ENVIRON`. |
| **CLINST_E_VERSION**   | The version of the program to install. |

Defined by *Extensions*:

| Name | Description |
  --- | ---
| **CLINST_E_REV**       | The revision (version) of the extension. Different than the version of the program it installs. |
| **CLINST_E_BIN_NAME**  | The name of the 'binary' (or whatever program) is being installed by the *Extension*. Used by various functions, basically to install wrappers and install files and such. If an extension is installing more than one program into the *Environment*, the *Extension* will probably need to implement its own internal functions (not using the **clinst** internal ones), and this variable wouldn't be used. |
| **CLINST_E_DLFILE**    | The file name of the file downloaded by the *Extension*. In practice it doesn't really matter what the value is, but the *Extension* controls it just in case. If the extension isn't downloading a file (say, when installing Python modules with `pip`) this isn't used. |
| **CLINST_E_OS**        | (optional) The name of an operating system. Only used to specify what file to download, if the program has OS-specific downloads. |
| **CLINST_E_ARCH**      | (optional) The name of a CPU architecture. Only used to specify what file to download, if the program has Archtecture-specific downloads. |
| **CLINST_E_BASEURL**   | (optional) The URL used to download artifacts, if downloading them with `curl`. Typically a `printf`-statement to be used with **CLINST_E_BASEURL_ARGS**. |
| **CLINST_E_BASEURL_ARGS** | (optional) Arguments to pass to **CLINST_E_BASEURL** when creating the url to download an artifact. Can have variables which will be interpolated at run-time. |

---

## Commands

Each *Extension* takes command-line arguments. Each extension may implement their own version of the command and provide the name of the command as part of a "help" command. If the extension doesn't list the command in its "help" output, **clinst** will try to use its own general-purpose function instead.

The following commands **MUST** be available in the *Extension*:
 - **help**
 - **variables**
 - **versions**

The following commands **MAY** be available in the *Extension* (they are called at *Extension* install time from **clinst**):
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
DEBUG=1 CLINST_HTTP_PATH=file://`pwd`/.. clinst -f -E aws=2.0.50 -e aws2050 aws
```

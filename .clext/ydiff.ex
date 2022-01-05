#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-ydiff}"
CLINST_E_REV="0.2.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
CLINST_E_BASEURL="https://pypi.org/pypi/$CLINST_E_NAME"
CLINST_E_BASEURL_ARGS=''
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
PYTHON="" PYMOD=""
_detect_python () {
    [ -z "${PYTHON:-}" ] && command -v python3 >/dev/null && PYTHON="python3"
    [ -z "${PYTHON:-}" ] && command -v python  >/dev/null && PYTHON="python"
    [ -z "${PYTHON:-}" ] && echo "$0: Error: please install python" && exit 1
    if    $PYTHON -c 'import virtualenv' ; then PYMOD="virtualenv -p $PYTHON"
    elif  $PYTHON -c 'import venv'       ; then PYMOD="venv"
    else  echo "$0: Error: please install Python module virtualenv or venv"; exit 1; fi
}
_ext_versions () {  clinst -E "$CLINST_E_NAME" -X versions_pypi "$CLINST_E_BASEURL/json" ;  }
_ext_download () {
    _detect_python
    mkdir -p "$CLINST_E_INSTDIR"
    $PYTHON -m $PYMOD --clear "$CLINST_E_INSTDIR/usr/"
    "$CLINST_E_INSTDIR/usr/bin/pip" download pip "$CLINST_E_NAME==$CLINST_E_VERSION"
}
_ext_unpack () { return 0 ; }
_ext_install_local () {
    "$CLINST_E_INSTDIR/usr/bin/pip" install -U pip
    "$CLINST_E_INSTDIR/usr/bin/pip" install "$CLINST_E_NAME==$CLINST_E_VERSION"
    # Add the 'bin/ symlink so _ext_test works
    mkdir -p "$CLINST_E_INSTDIR/bin"
    if    [ -h "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" -o -e "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" ]
    then  ln -sf "$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME" "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME"
    fi
    # Add the '/usr/bin/' folder so we can use the python, pip, etc files
    printf "pmunge \"$CLINST_E_INSTDIR/usr/bin\"\n" >> "$CLINST_E_INSTDIR/.env"
}

### The rest of this doesn't need to be modified
_ext_variables () { set | grep '^CLINST_E_' ; }
_ext_help () { printf "Usage: $0 CMD\n\nCommands:\n%s\n" "$(grep -e "^_ext_.* ()" "$0" | awk '{print $1}' | sed -e 's/_ext_//;s/^/  /g' | tr _ -)" ; }
if    [ $# -lt 1 ]
then  _ext_help ; exit 1
else  cmd="$1"; shift
      func="_ext_$(printf "%s\n" "$cmd" | tr - _)"
      [ -n "${CLINST_DIR:-}" -a -n "${CLINST_E_ENVIRON:-}" ] && [ -d "$CLINST_DIR/$CLINST_E_ENVIRON" ] && cd "$CLINST_DIR/$CLINST_E_ENVIRON"
      case "$cmd" in *) $func "$@" ;; esac
fi

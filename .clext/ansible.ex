#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLIV_E_NAME="${CLIV_E_NAME:-ansible}"
CLIV_E_REV="0.2.0"
CLIV_E_BIN_NAME="${CLIV_E_BIN_NAME:-$CLIV_E_NAME}"
CLIV_E_DLFILE="${CLIV_E_DLFILE:-$CLIV_E_NAME}"
CLIV_E_INSTDIR="${CLIV_E_INSTDIR:-$(pwd)}"
CLIV_E_BASEURL="https://pypi.org/pypi/$CLIV_E_NAME"
CLIV_E_BASEURL_ARGS=''
export CLIV_E_NAME CLIV_E_REV CLIV_E_BIN_NAME CLIV_E_DLFILE

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
_ext_versions () {  cliv -E "$CLIV_E_NAME" -X versions_pypi "$CLIV_E_BASEURL/json" | grep -e "^[0-9]\+\.[0-9]\+\.[0-9]\+$" ;  }
_ext_download () {
    _detect_python
    mkdir -p "$CLIV_E_INSTDIR"
    $PYTHON -m $PYMOD --clear "$CLIV_E_INSTDIR/usr/"
    "$CLIV_E_INSTDIR/usr/bin/pip" download pip "$CLIV_E_NAME==$CLIV_E_VERSION"
}
_ext_unpack () { return 0 ; }
_ext_install_local () {
    "$CLIV_E_INSTDIR/usr/bin/pip" install -U pip
    "$CLIV_E_INSTDIR/usr/bin/pip" install "$CLIV_E_NAME==$CLIV_E_VERSION"
    # Add the 'bin/ symlink so _ext_test works
    mkdir -p "$CLIV_E_INSTDIR/bin"
    if    [ -h "$CLIV_E_INSTDIR/usr/bin/$CLIV_E_BIN_NAME" -o -e "$CLIV_E_INSTDIR/usr/bin/$CLIV_E_BIN_NAME" ]
    then  ln -sf "$CLIV_E_INSTDIR/usr/bin/$CLIV_E_BIN_NAME" "$CLIV_E_INSTDIR/bin/$CLIV_E_BIN_NAME"
    fi
    # Add the '/usr/bin/' folder so we can use the python, pip, ansible-* files
    printf "pmunge \"$CLIV_E_INSTDIR/usr/bin\"\n" >> "$CLIV_E_INSTDIR/.env"
}

### The rest of this doesn't need to be modified
_ext_variables () { set | grep '^CLIV_E_' ; }
_ext_help () { printf "Usage: $0 CMD\n\nCommands:\n%s\n" "$(grep -e "^_ext_.* ()" "$0" | awk '{print $1}' | sed -e 's/_ext_//;s/^/  /g' | tr _ -)" ; }
if    [ $# -lt 1 ]
then  _ext_help ; exit 1
else  cmd="$1"; shift
      func="_ext_$(printf "%s\n" "$cmd" | tr - _)"
      [ -n "${CLIV_DIR:-}" -a -n "${CLIV_E_ENVIRON:-}" ] && [ -d "$CLIV_DIR/$CLIV_E_ENVIRON" ] && cd "$CLIV_DIR/$CLIV_E_ENVIRON"
      case "$cmd" in *) $func "$@" ;; esac
fi

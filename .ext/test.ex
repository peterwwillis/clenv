#!/usr/bin/env sh
# This is a sample extension used for tests
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLENV_E_NAME="${CLENV_E_NAME:-test}"
CLENV_E_REV="0.2.0"
CLENV_E_BIN_NAME="${CLENV_E_BIN_NAME:-$CLENV_E_NAME}"
CLENV_E_DLFILE="${CLENV_E_DLFILE:-$CLENV_E_NAME}"
CLENV_E_INSTDIR="${CLENV_E_INSTDIR:-$(pwd)}"
export CLENV_E_NAME CLENV_E_REV CLENV_E_BIN_NAME CLENV_E_DLFILE

### Extension-specific functions
_ext_versions () {  echo "1.0.0";  }
_ext_download () {
    mkdir -p "$CLENV_E_INSTDIR/download"
    printf '#!/usr/bin/env sh\necho "running test ($$) - $*"\n[ "${1:-}" = "--version" ] && exec echo Version 1.0.0\n[ $# -gt 0 ] && exec "$@"\nexit 0\n' > "$CLENV_E_INSTDIR/download/$CLENV_E_DLFILE"
}

### The rest of this doesn't need to be modified
_ext_variables () { set | grep '^CLENV_E_' ; }
_ext_help () { printf "Usage: $0 CMD\n\nCommands:\n%s\n" "$(grep -e "^_ext_.* ()" "$0" | awk '{print $1}' | sed -e 's/_ext_//;s/^/  /g' | tr _ -)" ; }
if    [ $# -lt 1 ]
then  _ext_help ; exit 1
else  cmd="$1"; shift
      func="_ext_$(printf "%s\n" "$cmd" | tr - _)"
      [ -n "${CLENV_DIR:-}" -a -n "${CLENV_E_ENVIRON:-}" ] && [ -d "$CLENV_DIR/$CLENV_E_ENVIRON" ] && cd "$CLENV_DIR/$CLENV_E_ENVIRON"
      case "$cmd" in *) $func "$@" ;; esac
fi

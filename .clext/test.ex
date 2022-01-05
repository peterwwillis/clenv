#!/usr/bin/env sh
# This is a sample extension used for tests
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-test}"
CLINST_E_REV="0.2.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
_ext_versions () {  echo "2.0.0" ; echo "1.0.0" ; }
_ext_download () {
    mkdir -p "$CLINST_E_INSTDIR/download"
    printf '#!/usr/bin/env sh\necho "running test ($$) - $*"\n[ "${1:-}" = "--version" ] && exec echo Version '"$CLINST_E_VERSION"'\n[ $# -gt 0 ] && exec "$@"\nexit 0\n' > "$CLINST_E_INSTDIR/download/$CLINST_E_DLFILE"
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

#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLIV_E_NAME="${CLIV_E_NAME:-eksctl}"
CLIV_E_REV="0.1.0"
CLIV_E_BIN_NAME="${CLIV_E_BIN_NAME:-$CLIV_E_NAME}"
CLIV_E_DLFILE="${CLIV_E_DLFILE:-$CLIV_E_NAME}.tgz"
CLIV_E_INSTDIR="${CLIV_E_INSTDIR:-$(pwd)}"
CLIV_E_OS="${CLIV_E_OS:-Linux}"
CLIV_E_ARCH="${CLIV_E_ARCH:-amd64}"
CLIV_E_GHREPOAPI="https://api.github.com/repos/weaveworks/$CLIV_E_NAME"
CLIV_E_BASEURL="https://github.com/weaveworks/$CLIV_E_NAME/releases/download/%s/${CLIV_E_NAME}_%s_%s.tar.gz"
CLIV_E_BASEURL_ARGS='"${CLIV_E_VERSION}" "${CLIV_E_OS}" "${CLIV_E_ARCH}"'
export CLIV_E_NAME CLIV_E_REV CLIV_E_BIN_NAME CLIV_E_DLFILE

### Extension-specific functions
_ext_versions () {
    CLIV_E_OS="$(echo $CLIV_E_OS | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }')" \
        CLIV -E "$CLIV_E_NAME" -X versions_ghreleases "$CLIV_E_GHREPOAPI" | grep -v -e "-rc\|alpha\|beta" | grep -e "^[0-9]"
}
_ext_unpack () {  CLIV -E "$CLIV_E_NAME" -X unpack_untar "/usr/bin" ;  }
_ext_test () {  "$CLIV_E_INSTDIR/bin/$CLIV_E_BIN_NAME" version 2>/dev/null 1>/dev/null ;  }

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

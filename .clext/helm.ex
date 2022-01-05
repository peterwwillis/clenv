#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLIV_E_NAME="${CLIV_E_NAME:-helm}"
CLIV_E_REV="0.1.0"
CLIV_E_BIN_NAME="${CLIV_E_BIN_NAME:-$CLIV_E_NAME}"
CLIV_E_DLFILE="${CLIV_E_DLFILE:-$CLIV_E_NAME}.tgz"
CLIV_E_INSTDIR="${CLIV_E_INSTDIR:-$(pwd)}"
CLIV_E_OS="${CLIV_E_OS:-linux}"
CLIV_E_ARCH="${CLIV_E_ARCH:-amd64}"
CLIV_E_GHREPOAPI="https://api.github.com/repos/helm/$CLIV_E_BIN_NAME"
CLIV_E_BASEURL="https://get.helm.sh/helm-v%s-%s-%s.tar.gz"
CLIV_E_BASEURL_ARGS='"${CLIV_E_VERSION}" "${CLIV_E_OS}" "${CLIV_E_ARCH}"'
export CLIV_E_NAME CLIV_E_REV CLIV_E_BIN_NAME CLIV_E_DLFILE

### Extension-specific functions
_ext_versions () {  cliv -E "$CLIV_E_NAME" -X versions_ghreleases "$CLIV_E_GHREPOAPI" | grep -v -e "-" ;  }
_ext_unpack () {  cliv -E "$CLIV_E_NAME" -X unpack_untar "/usr/" ;  }
_ext_install_local () {  cliv -E "$CLIV_E_NAME" -X install_local "/usr/${CLIV_E_OS}-${CLIV_E_ARCH}/${CLIV_E_NAME}" ;  }
_ext_test () {  "$CLIV_E_INSTDIR/bin/$CLIV_E_BIN_NAME" version --short 2>/dev/null 1>/dev/null ;  }


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

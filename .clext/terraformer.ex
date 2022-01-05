#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-terraformer}"
CLINST_E_REV="0.2.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
CLINST_E_PLATFORM="${CLINST_E_PLATFORM:-aws}"
CLINST_E_OS="${CLINST_E_OS:-linux}"
CLINST_E_ARCH="${CLINST_E_ARCH:-amd64}"
CLINST_E_GHREPOAPI="https://api.github.com/repos/GoogleCloudPlatform/$CLINST_E_BIN_NAME"
CLINST_E_BASEURL="https://github.com/GoogleCloudPlatform/$CLINST_E_NAME/releases/download/%s/$CLINST_E_NAME-%s-%s-%s"
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_PLATFORM}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
_ext_versions () {  clinst -E "$CLINST_E_NAME" -X versions_ghtags "$CLINST_E_GHREPOAPI" ;  }

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

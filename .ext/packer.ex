#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLENV_E_NAME="${CLENV_E_NAME:-packer}"
CLENV_E_REV="0.2.0"
CLENV_E_BIN_NAME="${CLENV_E_BIN_NAME:-$CLENV_E_NAME}"
CLENV_E_DLFILE="${CLENV_E_DLFILE:-$CLENV_E_NAME.zip}"
CLENV_E_INSTDIR="${CLENV_E_INSTDIR:-$(pwd)}"
CLENV_E_OS="${CLENV_E_OS:-linux}"
CLENV_E_ARCH="${CLENV_E_ARCH:-amd64}"
CLENV_E_HCURL="https://releases.hashicorp.com/$CLENV_E_NAME"
CLENV_E_BASEURL="$CLENV_E_HCURL/%s/$CLENV_E_NAME""_%s_%s_%s.zip"
CLENV_E_BASEURL_ARGS='"${CLENV_E_VERSION}" "${CLENV_E_VERSION}" "${CLENV_E_OS}" "${CLENV_E_ARCH}"'
export CLENV_E_NAME CLENV_E_REV CLENV_E_BIN_NAME CLENV_E_DLFILE

### Extension-specific functions
_ext_versions () {  clenv -E "$CLENV_E_NAME" -X versions_hc "$CLENV_E_HCURL" ;  }
_ext_unpack () {  clenv -E "$CLENV_E_NAME" -X unpack_unzip "/usr/bin" ;  }

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

#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="gh"
CLINST_E_REV="0.1.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-$CLINST_E_NAME}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}.tgz"
CLINST_E_OS="\$(uname_lc)"
CLINST_E_ARCH="\$(uname_m_amd)"
CLINST_E_GHREPOAPI="https://api.github.com/repos/cli/cli"
CLINST_E_BASEURL="https://github.com/cli/cli/releases/download/v%s/${CLINST_E_NAME}_%s_%s_%s.tar.gz"
CLINST_E_BASEURL_ARGS='"${CLINST_E_VERSION}" "${CLINST_E_VERSION}" "${CLINST_E_OS}" "${CLINST_E_ARCH}"'
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
_ext_versions () {  clinst -E "$CLINST_E_NAME" -X versions_ghreleases "$CLINST_E_GHREPOAPI" | grep -v -e "-" ;  }
_ext_unpack () {  clinst -E "$CLINST_E_NAME" -X unpack_untar "/usr" ;  }
_ext_install_local () {  clinst -E "$CLINST_E_NAME" -X install_local "/usr/gh_${CLINST_E_VERSION}_${CLINST_E_OS}_${CLINST_E_ARCH}/bin/${CLINST_E_NAME}" ;  }
_ext_test () {  "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME" version 2>/dev/null 1>/dev/null ;  }

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

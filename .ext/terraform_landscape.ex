#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLIV_E_NAME="${CLIV_E_NAME:-terraform_landscape}"
CLIV_E_REV="0.1.0"
CLIV_E_BIN_NAME="${CLIV_E_BIN_NAME:-landscape}"
CLIV_E_DLFILE="${CLIV_E_DLFILE:-$CLIV_E_NAME}"
CLIV_E_INSTDIR="${CLIV_E_INSTDIR:-$(pwd)}"
export CLIV_E_NAME CLIV_E_REV CLIV_E_BIN_NAME CLIV_E_DLFILE

### Extension-specific functions
GEM="${GEM:-gem}"
_detect_ruby () { [ -z "${GEM:-}" ] && echo "$0: Error: please install ruby 'gem' program" && exit 1 ; }
_ext_versions () {  gem query -r --versions -a --no-prerelease -q "$CLIV_E_NAME" | sed -e 's/^.\+ (//; s/, /\n/g; s/)$//' ;  }
_ext_download () { return 0 ; }
_ext_unpack () { return 0 ; }
_ext_install_local () {
    gem install --install-dir "$CLIV_E_INSTDIR/usr" "$CLIV_E_NAME" -v "$CLIV_E_VERSION"
    # Add the 'bin/ symlink so _ext_test works
    mkdir -p "$CLIV_E_INSTDIR/bin"
    printf "pmunge \"$CLIV_E_INSTDIR/usr/bin\"\n" >> "$CLIV_E_INSTDIR/.env"
    printf "export GEM_HOME=\"$CLIV_E_INSTDIR/usr/gems\"\n" >> "$CLIV_E_INSTDIR/.env"
    printf "export GEM_PATH=\"$CLIV_E_INSTDIR/usr\"\n" >> "$CLIV_E_INSTDIR/.env"
    printf "#!/bin/sh\n. \"$CLIV_E_INSTDIR\"/.env\nexec \"$CLIV_E_INSTDIR/usr/bin/$CLIV_E_BIN_NAME\" \"\$@\"\n" > "$CLIV_E_INSTDIR/bin/$CLIV_E_BIN_NAME"
    chmod +x "$CLIV_E_INSTDIR/bin/$CLIV_E_BIN_NAME"
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

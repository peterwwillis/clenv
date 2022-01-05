#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

### Extension-specific variables
CLINST_E_NAME="${CLINST_E_NAME:-terraform_landscape}"
CLINST_E_REV="0.1.0"
CLINST_E_BIN_NAME="${CLINST_E_BIN_NAME:-landscape}"
CLINST_E_DLFILE="${CLINST_E_DLFILE:-$CLINST_E_NAME}"
CLINST_E_INSTDIR="${CLINST_E_INSTDIR:-$(pwd)}"
export CLINST_E_NAME CLINST_E_REV CLINST_E_BIN_NAME CLINST_E_DLFILE

### Extension-specific functions
GEM="${GEM:-gem}"
_detect_ruby () { [ -z "${GEM:-}" ] && echo "$0: Error: please install ruby 'gem' program" && exit 1 ; }
_ext_versions () {  gem query -r --versions -a --no-prerelease -q "$CLINST_E_NAME" | sed -e 's/^.\+ (//; s/, /\n/g; s/)$//' ;  }
_ext_download () { return 0 ; }
_ext_unpack () { return 0 ; }
_ext_install_local () {
    gem install --install-dir "$CLINST_E_INSTDIR/usr" "$CLINST_E_NAME" -v "$CLINST_E_VERSION"
    # Add the 'bin/ symlink so _ext_test works
    mkdir -p "$CLINST_E_INSTDIR/bin"
    printf "pmunge \"$CLINST_E_INSTDIR/usr/bin\"\n" >> "$CLINST_E_INSTDIR/.env"
    printf "export GEM_HOME=\"$CLINST_E_INSTDIR/usr/gems\"\n" >> "$CLINST_E_INSTDIR/.env"
    printf "export GEM_PATH=\"$CLINST_E_INSTDIR/usr\"\n" >> "$CLINST_E_INSTDIR/.env"
    printf "#!/bin/sh\n. \"$CLINST_E_INSTDIR\"/.env\nexec \"$CLINST_E_INSTDIR/usr/bin/$CLINST_E_BIN_NAME\" \"\$@\"\n" > "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME"
    chmod +x "$CLINST_E_INSTDIR/bin/$CLINST_E_BIN_NAME"
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

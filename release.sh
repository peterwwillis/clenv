#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

_bumpver () {
    new_ver="$1"
    git checkout -- clenv
    sed -i -e "s/^CLENV_VER=.*/CLENV_VER=\"$new_ver\"/" clenv
    checksum="$(sha256sum clenv | awk '{print $1}')"
    git checkout -- README.md
    sed -i -e "s/^\([[:space:]]\+&& echo \"\)[0-9a-f]\+  /\1$checksum  /" README.md
}
_checksums () {
    sha256sum clenv .ext/*.ex > .CHECKSUMS.s256
}

if [ $# -lt 1 ] ; then
    cat <<EOUSAGE
Usage: $0 CMD [..]

Commands:
  bumpver VERSION
  checksums
EOUSAGE
    exit 1
fi

cmd="$1"; shift
case "$cmd" in
    bumpver)    _bumpver "$@" ;;
    checksums)  _checksums "$@" ;;
esac

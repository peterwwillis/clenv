#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

_bumpver () {
    new_ver="$1"
    git checkout -- cliv
    sed -i -e "s/^CLIV_VER=.*/CLIV_VER=\"$new_ver\"/" cliv
    checksum="$(sha256sum cliv | awk '{print $1}')"
    git checkout -- README.md
    sed -i -e "s/^\([[:space:]]\+&& echo \"\)[0-9a-f]\+  /\1$checksum  /" README.md
    sed -i -e "s/\(raw\.githubusercontent\.com\/peterwwillis\/cliv\/v\)[0-9.]\+\(\/cliv\)/\1$new_ver\2/g" README.md
}
_extlist () {
    extensions="$(ls .ext/*.ex | grep -ve "test\.ex" | sed -e 's/^\.ext\/\(.\+\)\.ex$/**\1**, /g' | xargs | sed -e 's/,$//')"
    sed -i -e "s/\(to automate downloading & installing any application\).*)/\1 ($extensions)/" README.md
}
_checksums () {
    sha256sum cliv .ext/*.ex > CHECKSUMS.sha256
}
_signatures () {
    for i in cliv .ext/*.ex ; do
        gpg -s -a -b -o $i.asc $i
    done
}

if [ $# -lt 1 ] ; then
    cat <<EOUSAGE
Usage: $0 CMD [..]

Commands:
  bumpver VERSION
  checksums
  extlist
  signatures
  all VERSION
EOUSAGE
    exit 1
fi

cmd="$1"; shift
case "$cmd" in
    bumpver)    _bumpver "$@" ;;
    checksums)  _checksums ;;
    extlist)    _extlist ;;
    signatures) _signatures ;;
    all)        _bumpver "$1" ;
                _checksums ; 
                _extlist ;
                _signatures ;;
    *) echo "Error: bad command"; exit 1 ;;
esac

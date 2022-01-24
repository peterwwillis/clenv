#!/usr/bin/env sh
set -eu
[ "${DEBUG:-0}" = "1" ] && set -x

_bumpver () {
    new_ver="$1"
    git checkout -- clinst
    # CLINST_VER="${CLINST_VER:-v3.0.0}"
    sed -i -e "s/^CLINST_VER=.*/CLINST_VER=\"\${CLINST_VER:-v$new_ver}\"/" clinst
    checksum="$(sha256sum clinst | awk '{print $1}')"
    git checkout -- README.md
    sed -i -e "s/^\([[:space:]]\+&& echo \"\)[0-9a-f]\+  /\1$checksum  /" README.md
    sed -i -e "s/\(raw\.githubusercontent\.com\/peterwwillis\/clinst\/v\)[0-9.]\+\(\/clinst\)/\1$new_ver\2/g" README.md
}
_extlist () {
    extensions="$(ls .clext/*.ex .clext/*.e | grep -ve "test\.ex" | sed -e 's/^\.clext\/\(.\+\)\.ex\?$/**\1**, /g' | xargs | sed -e 's/,$//')"
    sed -i -e "s/\(to automate downloading & installing applications\).*)/\1 ($extensions)/" README.md
}
_checksums () {
    sha256sum clinst .clext/*.ex .clext/*.e > CHECKSUMS.sha256
}
_signatures () {
    #for i in clinst .clext/*.ex .clext/*.e ; do
    #    gpg -s -a -b -o $i.asc $i
    #done
    return 0
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

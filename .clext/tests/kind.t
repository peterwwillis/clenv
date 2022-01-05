#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(clinst -e "ext-ver-$ext_ver" $ext_name version)"
    if [ ! "$result" = "kind v0.11.1 go1.16.4 linux/amd64" ] ; then
        return 1
    fi
}

ext_ver=0.11.1
ext_tests="ext_install versions vers_check"

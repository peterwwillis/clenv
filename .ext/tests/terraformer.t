#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(cliv -e "ext-ver-$ext_ver" $ext_name --version)"
    if [ ! "$result" = "version v0.8.14" ] ; then
        return 1
    fi
}

ext_ver=0.8.14
ext_tests="ext_install versions vers_check"

#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(clenv -e "ext-ver-$ext_ver" $ext_name --version 2>&1 | tail -1)"
    if [ ! "$result" = "2.30.0" ] ; then
        return 1
    fi
}

ext_ver=2.30.0
ext_tests="ext_install versions vers_check"

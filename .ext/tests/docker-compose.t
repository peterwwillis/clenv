#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(cliv -e "ext-ver-$ext_ver" $ext_name --version 2>&1 | tail -1)"
    if [ ! "$result" = "docker-compose version 1.29.2, build 5becea4c" ] ; then
        return 1
    fi
}

ext_ver=1.29.2
ext_tests="ext_install versions vers_check"

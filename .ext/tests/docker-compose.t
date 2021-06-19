#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_1 () {
    # Test extension install
    if ! clenv -f -E "$ext_name=$ext_ver" -e "ext-ver-$ext_ver" ; then
        return 1
    fi
}
_t_2 () {
    # Test version check
    result="$(clenv -e "ext-ver-$ext_ver" $ext_name --version 2>&1 | tail -1)"
    if [ ! "$result" = "docker-compose version 1.29.2, build 5becea4c" ] ; then
        return 1
    fi
}

ext_ver=1.29.2
ext_tests="1 2"

#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(clinst -e "ext-ver-$ext_ver" $ext_name --version | awk '{print $2}')"
    if [ ! "$result" = "2.2.19" ] ; then
        return 1
    fi
}

ext_ver=2.2.19
ext_tests="ext_install versions vers_check"

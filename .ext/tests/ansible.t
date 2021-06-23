#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(clenv -e "ext-ver-$ext_ver" $ext_name --version 2>/dev/null | head -1 | awk '{print $1}')"
    if [ ! "$result" = "ansible" ] ; then
        return 1
    fi
}

ext_ver=4.1.0
ext_tests="ext_install versions vers_check"

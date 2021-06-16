#!/bin/sh
set -ux

_t_1 () {
    # Test extension install
    cliv -f -I "$ext_name=$ext_ver" "ext-ver-$ext_ver"
}
_t_2 () {
    # Test version check
    result="$(cliv "ext-ver-$ext_ver" $ext_name --version)"
    if [ ! "$result" = "version v0.8.14" ] ; then
        return 1
    fi
}

ext_ver=0.8.14
ext_tests="1 2"

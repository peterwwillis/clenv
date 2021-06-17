#!/bin/sh
set -ux

_t_1 () {
    # Test extension install
    if ! clenv -f -I "$ext_name=$ext_ver" "ext-ver-$ext_ver" ; then
        return 1
    fi
}
_t_2 () {
    # Test version check
    result="$(clenv "ext-ver-$ext_ver" $ext_name --version)"
    if [ ! "$result" = "yq version 4.9.6" ] ; then
        return 1
    fi
}

ext_ver=4.9.6
ext_tests="1 2"

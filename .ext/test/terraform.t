#!/bin/sh
set -ux

_t_1 () {
    # Test extension install
    clenv -f -I "$ext_name=$ext_ver" "ext-ver-$ext_ver"
}
_t_2 () {
    # Test version check
    result="$(clenv "ext-ver-$ext_ver" $ext_name --version)"
    if [ ! "$result" = "Terraform v0.12.31" ] ; then
        return 1
    fi
}

ext_ver=0.12.31
ext_tests="1 2"

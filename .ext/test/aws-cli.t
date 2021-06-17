#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_1 () {
    # Test extension install
    if ! clenv -f -I "$ext_name=$ext_ver" "ext-ver-$ext_ver" ; then
        return 1
    fi
}
_t_2 () {
    # Test version check
    result="$(clenv "ext-ver-$ext_ver" aws --version)"
    if [ $(expr "$result" : "aws-cli/2.2.12 Python/.* exe/.*") -eq 0 ] ; then
        return 1
    fi
}

ext_ver=2.2.12
ext_tests="1 2"

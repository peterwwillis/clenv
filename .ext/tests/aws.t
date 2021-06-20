#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_ext_install () {
    # Test extension install
    if ! clenv -f -E "$ext_name=$ext_ver" -e "ext-ver-$ext_ver" ; then
        return 1
    fi
}
_t_vers_check () {
    # Test version check
    result="$(clenv -e "ext-ver-$ext_ver" aws --version)"
    if [ $(expr "$result" : "aws-cli/2.2.12 Python/.* exe/.*") -eq 0 ] ; then
        return 1
    fi
}

ext_ver=2.2.12
ext_tests="ext_install vers_check"

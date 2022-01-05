#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(clinst -e "ext-ver-$ext_ver" $ext_name --version)"
    if [ $(expr "$result" : "aws-cli/2.2.12 Python/.* exe/.*") -eq 0 ] ; then
        return 1
    fi
}

ext_ver=2.2.12
ext_tests="ext_install versions vers_check"

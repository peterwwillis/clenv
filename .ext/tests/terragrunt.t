#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(cliv -e "ext-ver-$ext_ver" $ext_name --version | head -1)"
    if [ ! "$result" = "terragrunt version v0.31.0" ] ; then
        return 1
    fi
}

ext_ver=0.31.0
ext_tests="ext_install versions vers_check"

#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

_t_vers_check () {
    # Test version check
    result="$(cliv -E "$ext_name" -e "ext-ver-$ext_ver" landscape --version 2>/dev/null | tail -1)"
    echo "result: '$result'"
    if [ ! "$result" = "Terraform Landscape 0.3.4" ] ; then
        return 1
    fi
}

ext_ver=0.3.4
ext_tests="ext_install versions vers_check"

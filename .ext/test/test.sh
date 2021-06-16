#!/bin/sh
set -ux

# Must pass file paths ending in '.t'
_fail=0 _pass=0
for i in "$@" ; do
    tmp="$(mktemp -d)"
    export CLIV_HTTP_PATH="file://`pwd`"
    export CLIV_DIR="$tmp"

    ext_name="$(basename "$i" .t)"
    . "$i"
    fail=0 pass=0
    for t in $ext_tests ; do
        if ! _t_$t ; then
            echo "$0: $ext_name: Test $t failed"
            fail=$(($fail+1))
        else
            echo "$0: $ext_name: Test $t succeeded"
            pass=$(($pass+1))
        fi
    done

    rm -rf "$tmp"
    [ $fail -gt 0 ] && echo "$0: $ext_name: Failed $fail tests" && _fail="$(($_fail+$fail))"
    _pass=$(($_pass+$pass))
done


echo "$0: Passed _pass tests"
if [ $_fail -gt 0 ] ; then
    echo "$0: Failed $_fail tests"
    exit 1
fi

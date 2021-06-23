#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u


### Common Tests for Extensions
_t_ext_install () {
    # Test extension install
    if ! clenv -f -E "$ext_name=$ext_ver" -e "ext-ver-$ext_ver" ; then
        return 1
    fi
}
_t_versions () {
    # Test getting versions.
    # NOTE: This MUST be run AFTER the 'Text extension install' test, as that 
    # will actually download the extension that we run in this test.
    # Confirm the 'ext_tests=' in each '*.t' !
    clenv -E "$ext_name" -X versions >/dev/null
}

### Main test.sh
_main () {
    # Must pass file paths ending in '.t'
    _fail=0 _pass=0 _failedtests=""
    for i in "$@" ; do
        ext_name="$(basename "$i" .t)"
        tmp="$(mktemp -d)"
        export CLENV_HTTP_PATH="file://`pwd`"
        export CLENV_DIR="$tmp"
        # Variables seen by *.t: $ext_name , $tmp
        # Environment variables exported: CLENV_HTTP_PATH, CLENV_DIR
        . "$i"
        fail=0 pass=0
        for t in $ext_tests ; do
            if ! _t_$t ; then
                echo "$0: $ext_name: Test $t failed"
                fail=$(($fail+1))
                _failedtests="$_failedtests $ext_name:$t"
                pwd
                ls -la .??* *
            else
                echo "$0: $ext_name: Test $t succeeded"
                pass=$(($pass+1))
            fi
        done

        rm -rf "$tmp"
        [ $fail -gt 0 ] && echo "$0: $ext_name: Failed $fail tests" && _fail="$(($_fail+$fail))"
        _pass=$(($_pass+$pass))
    done
}

_main "$@"
echo "$0: Passed $_pass tests"
if [ $_fail -gt 0 ] ; then
    echo "$0: Failed $_fail tests: $_failedtests"
    exit 1
fi

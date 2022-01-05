#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

# Test wrapper-in-wrapper
_t_wrapper_in_wrapper () {
    # Install environments
    CLINST_E_BIN_NAME=foo clinst -E test -e test-env-1
    CLINST_E_BIN_NAME=bar clinst -E test -e test-env-2
    export PATH="$CLINST_DIR/.bin:$PATH"
    foo bar
}

# Test switching default version
_t_wrapper_switch_default () {
    clinst -E test -e test=1.0.0
    clinst -E test -e test=2.0.0
    clinst -D test=1.0.0
    clinst test --version | grep -e "^Version 1.0.0"
    clinst -D test=2.0.0
    clinst test --version | grep -e "^Version 2.0.0"
}

ext_tests="wrapper_in_wrapper wrapper_switch_default"

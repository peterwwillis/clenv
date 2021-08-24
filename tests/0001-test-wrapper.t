#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

# Test wrapper-in-wrapper
_t_wrapper_in_wrapper () {
    # Install environments
    CLIV_E_BIN_NAME=foo cliv -E test -e test-env-1
    CLIV_E_BIN_NAME=bar cliv -E test -e test-env-2
    export PATH="$CLIV_DIR/.bin:$PATH"
    foo bar
}

# Test switching default version
_t_wrapper_switch_default () {
    cliv -E test -e test=1.0.0
    cliv -E test -e test=2.0.0
    cliv -D test=1.0.0
    cliv test --version | grep -e "^Version 1.0.0"
    cliv -D test=2.0.0
    cliv test --version | grep -e "^Version 2.0.0"
}

ext_tests="wrapper_in_wrapper wrapper_switch_default"

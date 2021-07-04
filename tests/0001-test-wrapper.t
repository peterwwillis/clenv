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

ext_tests="wrapper_in_wrapper"

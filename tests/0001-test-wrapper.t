#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

# Test wrapper-in-wrapper
_t_wrapper_in_wrapper () {
    # Install environments
    CLENV_E_BIN_NAME=foo clenv -E test -e test-env-1
    CLENV_E_BIN_NAME=bar clenv -E test -e test-env-2
    export PATH="$CLENV_DIR/.bin:$PATH"
    foo bar
}

ext_tests="wrapper_in_wrapper"

#!/usr/bin/env sh
[ "${DEBUG:-0}" = "1" ] && set -x
set -u

# Test wrapper-in-wrapper
_t_1 () {
    # Install environments
    CLENV_E_BIN_NAME=foo clenv -I test test-env-1
    CLENV_E_BIN_NAME=bar clenv -I test test-env-2
    tree -a $CLENV_DIR
    export PATH="$CLENV_DIR/.bin:$PATH"
    foo bar
}

ext_tests="1"

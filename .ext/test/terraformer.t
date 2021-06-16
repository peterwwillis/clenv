#!/bin/sh
set -eux

_test_1 () {
    tf_ver=0.8.14
    tmp="$(mktemp -d)"
    export CLIV_HTTP_PATH="file://`pwd`"
    export CLIV_DIR="$tmp"
    cliv -f -I "terraformer=$tf_ver" "tfer-ver-$tf_ver"
    cliv "tfer-ver-$tf_ver" terraform --version
    rm -rf "$tmp"
}

_test_1

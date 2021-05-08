#!/bin/sh
set -eux

_test_1 () {
    tf_ver=0.12.31
    tmp="$(mktemp -d)"
    export CLIV_HTTP_PATH="file://`pwd`"
    export CLIV_DIR="$tmp"
    cliv -f -I "terraform=$tf_ver" "tf-ver-$tf_ver"
    cliv "tf-ver-$tf_ver" terraform --version
    rm -rf "$tmp"
}

_test_1

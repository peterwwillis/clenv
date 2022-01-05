
.PHONY: test test-main test-extensions
test: test-main test-extensions

test-extensions:
	export PATH="`pwd`:$$PATH" ; \
    ./test.sh .clext/tests/*.t

test-main:
	export PATH="`pwd`:$$PATH" ; \
    ./test.sh tests/*.t

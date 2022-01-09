
.PHONY: test test-main test-extensions
test: test-main test-extensions

test-extensions:
	export PATH="`pwd`:$$PATH" ; \
    TESTSH_ENVRC="`pwd`/.testshrc" TESTSH_LOGGING=1 ./test.sh .clext/tests/*.t

test-main:
	export PATH="`pwd`:$$PATH" ; \
    TESTSH_ENVRC="`pwd`/.testshrc" TESTSH_LOGGING=1 ./test.sh tests/*.t

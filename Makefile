test:
	export PATH="`pwd`:$$PATH" ; \
    for test in .ext/test/*.t ; do \
	    $$test ; \
    done

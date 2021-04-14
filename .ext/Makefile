shellcheck:
	for i in * ; do \
        case "$$i" in \
            Makefile|README.md) continue ;; \
            *)                  [ ! -d "$$i" ] && shellcheck $$i ;; \
        esac \
    done

- [x] Fix recursion bug due to PATHs and different executables/wrappers
      This needs to unset the wrapper dir from PATH after cliv runs.
      Check rbenv for implementation hints.
- [ ] `test.sh` should stop running sub-tests once the first one in a test fails.
      Otherwise you just keep running sub-tests you know probably won't work.
- [x] Write tests for the wrapper mode.
      - Needs to test one wrapper-application calling another wrapper-application
- [ ] Fix extensions to not overwrite '.bin' wrapper if it already exists.
      (*unless* $CLIV_FORCE=1)
- [ ] Fix extensions to not try to remove $CLIV_E_INSTDIR as that might be the
      current directory if otherwise unspecified

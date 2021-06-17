- [ ] Fix recursion bug due to PATHs and different executables/wrappers
      This needs to unset the wrapper dir from PATH after clenv runs.
      Check rbenv for implementation hints.
- [ ] `test.sh` should stop running sub-tests once the first one in a test fails.
      Otherwise you just keep running sub-tests you know probably won't work.

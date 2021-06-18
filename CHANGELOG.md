# Changelog

## [1.3.0] - 2021-06-17

### Added
 - Test extension and core tests, including a test of the wrapper functionality.
 - GitHub Actions/Workflow to run CI tests on pull requests

### Changed
 - '-W' wrapper mode now requires an extension name. If the execution function
   is eventually run, that requires the environment name (and optional commands).
 - Each extension's binary file and wrapper names can now be overridden by passing
   *$CLENV_E_BIN_FILE*.

### Fixed
 - Wrapper mode would result in an infinite loop if one wrapper called another
   wrapper.
 - Terraform test only looks for the first version line now to work around notice
   about upgrading.

---

## [1.2.0] - 2021-06-16

### Added
 - `ADDME.md` (feature requests)
 - More documentation of how *Extensions* work
 - New extensions: aws-cli, docker-compose, packer, yq
### Changed
 - Change terminology "ALIAS" to "ENVIRON"
 - Install downloads into a ./download/ folder (simpler cleanup)
 - Install unpacked files into a ./usr/ folder
 - Install wrapper binaries as file named *$BIN_FILE* rather than *$CLENV_E_NAME*
 - Simplify some environment variables used by download (OS, ARCH, etc)
 - In extensions, `$CLENV_E_INSTDIR` defaults to current directory

---

## [1.1.0] - 2021-06-16
### Added
 - saml2aws extension and test
 - CHANGELOG.md

---

## [1.0.0] - 2021-06-16
### Added
 - Terraformer extension and test
 - Some docs on the version wrapper functionality

### Changed
 - Tests are refactored to be a little simpler
 - Renamed project from cliv to clenv

### Fixed
 - Wrapper functionality should work better now (but still isn't 100% - see FIXME.md)

- [x] Rename from cliv to cliv

- [ ] Version the local extensions, so you can change cliv and it'll use an extension made for that version of cliv

- [x] Allow switching the default version/environment for a wrapper application, without re-downloading/reinstalling
      a version already installed. Currently how the 'default' one works and 'pinned' versions work are different
      in ways that are probably not intuitive and definitely wasteful.

- [ ] Do not re-install an extension/version if it's already installed, unless '-f' option is provided.
      (currently it will keep re-installing (ex. `cliv -E packer`), wasting bandwidth/time)

- [ ] Verify signatures
  - [ ] Implement checking cryptographic signature of cliv
  - [ ] Implement checking cryptographic signature of cliv extensions
  - [ ] Implement checking cryptographic signature of downloads
  - [ ] Add a test for the GitHub custom extension installer

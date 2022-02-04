- [x] Rename from clinst to clinst

- [ ] Version the local extensions, so you can change clinst and it'll use an extension made for that version of clinst

- [x] Allow switching the default version/environment for a wrapper application, without re-downloading/reinstalling
      a version already installed. Currently how the 'default' one works and 'pinned' versions work are different
      in ways that are probably not intuitive and definitely wasteful.

  [ ] Fix current bug where specifying "-E terraform=VERSION terraform cmd <..>" is continuing to download the same
      binary over and over. This should only happen with '-f' also passed.

  [ ] Document how to use clinst to switch wrapper paths when executing commands
      ('clinst -e terraform=1.0.10 terraformsh plan' <-- not directly calling terraform but changing which is used)

- [ ] Do not re-install an extension/version if it's already installed, unless '-f' option is provided.
      (currently it will keep re-installing (ex. `clinst -E packer`), wasting bandwidth/time)

- [ ] Verify signatures
  - [ ] Implement checking cryptographic signature of clinst
  - [ ] Implement checking cryptographic signature of clinst extensions
  - [ ] Implement checking cryptographic signature of downloads
  - [ ] Add a test for the GitHub custom extension installer

 - [ ] Fix bug: Downloading envs versus running them.
       If you run 'clinst -E terraform=1.1.2 terraform --help' it will run the correct terraform environment.
       If you run 'clinst -E terraform=1.1.2 ./some_script.sh', it will download Terraform again, even if it already exists in the environment.

 - [ ] Fix bug: Downloading extensions
       If you run 'clinst -E terraform=1.1.4' or 'clinst -E terraform=1.1.4 -e terraform=1.1.4' and it already exists, it will download it again.
       If you run 'clinst -E terraform=1.1.4 terraform' it will run '~/.clinst/terraform/bin/terraform'

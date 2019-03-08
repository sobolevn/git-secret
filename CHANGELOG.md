# Changelog

## {{Next Version}}

- Support SECRETS_VERBOSE env var to enable verbosity (#323)
- Document SECRETS_VERBOSE and improve env var docs (#396)
- Use gpg without --quiet when decrypting in verbose mode (#394)
- Add -v 'verbose' option to 'tell', showing gpg output (#320)
- Fix link to homebrew's git-secret in README.md (#310)
- Update CHANGELOG.md to mention fix for #281 in v0.2.5 (#311)
- Remove diagnostic output from test results (#324)
- Remove un-needed redirection in 'reveal' (#325)
- Remove unused functions from _git_secret_tools.sh
- Fix link to current contributors in CONTRIBUTING.md (#331)
- Fix tests when running from git hooks (#334)
- Fix typo, remove temp directory in utils/tests.sh (#347)
- Update git-secret.io, fix utils/gh-branch.sh to use 'git all --add' (#344)
- Change 'init' to never ignore .secret files (#362)
- Add text explaining git-secret Style Guide and Development Philosophy
- Upgrade bats-core to v1.1.0, import bats-core into vendor/bats-core (#377)
- Spelling fixes
- Fix re: SECRETS_DIR in 'init' and SECRETS_EXTENSION in test_reveal.bats (#364)
- Use SECRETS_GPG_COMMAND env var in gpg version check (#389)
- Use Shellcheck on tests/ files, changes for Shellcheck in tests/ (#368)
- Add header to git-secret.7 man page, for debian and doc improvement (#386)

## Version 0.2.5

- Added notes about packages and for package maintainers (#281)
- Fix issues with spaces in paths and filenames (#226, #135)
- Fix issue when 'hide' used in subdir of repo (#230)
- Fix issues in 'changes' with trailing newlines (#291)
- Fix 'hide' to only count actually hidden files as hidden (#280)
- Fixed bugs and improved error messages (#174)
- Add -l option to whoknows, which shows key expiration dates (#283)
- Add -P option (preserve permissions) to reveal and hide (#172)
- Add -F option (force, changing some errors to warnings) to hide and reveal (#253)
- Add tests for expired gpg keys, and gpg keys with only emails (#276)
- Add support for FreeBSD (#244)
- Issue error message when unable to hide a secret (#202, #238)
- Accept gpg key with no name, only an email (#227)
- Require keys to be specified by email, as documented (#267)
- Disallow 'git secret tell' or 'killperson' with emails that are not in keychain (also #267)
- Allow user to specify name of secret dir at runtime using SECRETS_DIR env var, and test (#247, #250)
- Improve documentation regarding operation with different versions of GPG (#274, #182)
- Documentation improvements, error message and text improvements, and typo fixes (#254)
- git-secret RFC#001 added, documenting a path towards independence from gpg binary formats (#208)

## Version 0.2.4

- Added `git secret cat` feature (#141)
- `git secret hide` and `git secret changes` check for files more carefully (#153, #154)
- Documentation and error message improvements (#126, #136, #144, #150)
- Build and CI fixes (#152, #179, #186, #188, #189)
- Migrate to `bats-core` bash testing framework

## Version 0.2.3

- Added `-m` option to `hide` command, files will only be hidden when modifications are detected (#92)
- Changed how path mappings file works: colon delimited FSDB (#92)
- Fixed `gnupg` >= 2.1 CI tests (#6)
- Now users can run local CI tests using test-kitchen (#6)
- Migrated travis ci tests to test-kitchen for Linux platforms.
- `git secret init` now adds `random_seed` to `.gitignore` (#93)
- Added more `gpg` version to test matrix (#99)
- Dropped `git check-ignore`, using `git add --dry-run` instead to check for ignored files (#105,#38)
- Added CentOS to test matrix (#38,#91)
- All tested Linux platforms now use latest release of `shellcheck`
- Added Alpine to test matrix, and apk is now built. (#75)

## Version 0.2.2

- Change how the `usage` command works (#48)
- Now `git-secret` works from any place inside `git-tree` (#56)
- Added `-d` option to the `hide` command: it deletes unencrypted files (#62)
- Added new command `changes` to see the diff between the secret files (#64)
- Fixed bug when `_user_required` was not working after re-importing keys (#74)
- Now it is possible to provide multiple emails to the `killperson` command (#73)
- Now it is possible to provide multiple emails to the `tell` command (#72)
- Now every doc in this project refer to `git-secret.io` instead of old `gh-pages` website (#71)
- Now installation section is removed from main `man` file (#70)
- Now "See also" sections in the `man` pages are clickable (#69)
- Added "Manual" section to the manuals (#61)
- Added `CentOS` container for `ci` testing (#38)
- Tests are refactored. Added `clean` command tests, removed a lot of hard-coded things, moved tests execution from `./temp` folder to `/tmp`, added a lot of new check in old tests, and some new test cases (#52)
- Refactored `hide` and `clean` commands to be shorter
- `shellcheck` is now supported with `make lint`

## Version 0.2.1

- Now everything is tested inside the `docker`-containers and `OSX` (MacOS) images on `travis`.
- Added autodeploy to `bintray` in `.travis.yml`.
- Added `.ci/` folder for continuous integration, refactored `utils/` folder.
- Added `CONTRIBUTING.md` and `LICENSE.md`.
- New brand logo in the `README.md`.
- Everything is `shellcheck`ed (except `tests/`).

## Version 0.2.0

- Added `changes` command to see the difference between current version of the hidden files and the committed one
- Added `-f` option to the `reveal` command to remove prompts
- Changed the way files were decrypted, now it is a separate function
- Some bugs are fixed
- New installation instructions

## Version 0.1.2

- Added `-i` option to the `git-secret-add` command, which auto adds unignored files to the `.gitignore`
- Documentation improved with `Configuration` section
- Added extra tests: for custom filenames and new features
- `Makefile` improvements with `.PHONY` and `install` target
- `.github` templates added

## Version 0.1.1

- Added `--dry-run` option to the `git secret` command, which prevents any actions.
- Now `install_full_fixture()` returns a fingerprint
- Now `uninstall_full_fixture()` receives two args
- Fixed bug when tests were failing with `gpg2`
- New travis strategy: testing both `gpg` and `gpg2`
- Removed animation from docs, now using `asciinema.org`

## Version 0.1.0

- Initial release

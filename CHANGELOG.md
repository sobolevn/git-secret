# Changelog

## {{Next Version}}

- Feature: Support SECRETS_VERBOSE env var to enable verbosity (#323)
- Feature: Use gpg without --quiet when decrypting in verbose mode (#394)
- Feature: Add -v 'verbose' option to 'tell', showing gpg output (#320)
- Feature: Change 'init' to never ignore .secret files (#362)
- Fix: Update git-secret.io, fix utils/gh-branch.sh to use 'git all --add' (#344)
- Fix: Fix link to homebrew's git-secret in README.md (#310)
- Fix: Remove diagnostic output from test results (#324)
- Fix: Remove un-needed redirection in 'reveal' (#325)
- Fix: Remove unused functions from _git_secret_tools.sh
- Fix: Fix link to current contributors in CONTRIBUTING.md (#331)
- Fix: Fix tests when running from git hooks (#334)
- Fix: Fix typo, remove temp directory in utils/tests.sh (#347)
- Fix: Spelling fixes
- Fix: Fix re: SECRETS_DIR in 'init' and SECRETS_EXTENSION in test_reveal.bats (#364)
- Fix: Use SECRETS_GPG_COMMAND env var in gpg version check (#389)
- Fix: Use Shellcheck on tests/ files, changes for Shellcheck in tests/ (#368)
- Fix: Add header to git-secret.7 man page, for debian and doc improvement (#386)
- Doc: Document SECRETS_VERBOSE and improve env var docs (#396)
- Doc: Update CHANGELOG.md to mention fix for #281 in v0.2.5 (#311)
- Doc: Add text explaining git-secret Style Guide and Development Philosophy
- Build: Upgrade bats-core to v1.1.0, import bats-core into vendor/bats-core (#377)

## Version 0.2.5

- Feature: Add support for FreeBSD (#244)
- Feature: Add -l option to whoknows, which shows key expiration dates (#283)
- Feature: Add -P option (preserve permissions) to reveal and hide (#172)
- Feature: Add -F option (force, changing some errors to warnings) to hide and reveal (#253)
- Feature: Allow user to specify name of secret dir at runtime using SECRETS_DIR env var, and test (#247, #250)
- Fix: Fix issues with spaces in paths and filenames (#226, #135)
- Fix: Fix issue when 'hide' used in subdir of repo (#230)
- Fix: Fix issues in 'changes' with trailing newlines (#291)
- Fix: Fix 'hide' to only count actually hidden files as hidden (#280)
- Fix: Fixed bugs and improved error messages (#174)
- Fix: Issue error message when unable to hide a secret (#202, #238)
- Fix: Accept gpg key with no name, only an email (#227)
- Fix: Require keys to be specified by email, as documented (#267)
- Fix: Disallow 'git secret tell' or 'killperson' with emails that are not in keychain (also #267)
- Doc: Added notes about packages and for package maintainers (#281)
- Doc: Improve documentation regarding operation with different versions of GPG (#274, #182)
- Doc: Documentation improvements, error message and text improvements, and typo fixes (#254)
- Doc: git-secret RFC#001 added, documenting a path towards independence from gpg binary formats (#208)
- Test: Add tests for expired gpg keys, and gpg keys with only emails (#276)

## Version 0.2.4

- Feature: Added `git secret cat` feature (#141)
- Fix: `git secret hide` and `git secret changes` check for files more carefully (#153, #154)
- Doc: Documentation and error message improvements (#126, #136, #144, #150)
- Build: Build and CI fixes (#152, #179, #186, #188, #189)
- Build: Migrate to `bats-core` bash testing framework

## Version 0.2.3

- Feature: Added `-m` option to `hide` command, files will only be hidden when modifications are detected (#92)
- Feature: Changed how path mappings file works: colon delimited FSDB (#92)
- Feature: `git secret init` now adds `random_seed` to `.gitignore` (#93)
- Fix: Dropped `git check-ignore`, using `git add --dry-run` instead to check for ignored files (#105,#38)
- Fix: Fixed `gnupg` >= 2.1 CI tests (#6)
- Test: Now users can run local CI tests using test-kitchen (#6)
- Test: Migrated travis ci tests to test-kitchen for Linux platforms.
- Test: Added more `gpg` version to test matrix (#99)
- Build: Added CentOS to test matrix (#38,#91)
- Build: All tested Linux platforms now use latest release of `shellcheck`
- Build: Added Alpine to test matrix, and apk is now built. (#75)

## Version 0.2.2

- Feature: Change how the `usage` command works (#48)
- Feature: Now `git-secret` works from any place inside `git-tree` (#56)
- Feature: Added `-d` option to the `hide` command: it deletes unencrypted files (#62)
- Feature: Added new command `changes` to see the diff between the secret files (#64)
- Feature: Now it is possible to provide multiple emails to the `killperson` command (#73)
- Feature: Now it is possible to provide multiple emails to the `tell` command (#72)
- Fix: Fixed bug when `_user_required` was not working after re-importing keys (#74)
- Fix: Refactored `hide` and `clean` commands to be shorter
- Doc: Now every doc in this project refer to `git-secret.io` instead of old `gh-pages` website (#71)
- Doc: Now installation section is removed from main `man` file (#70)
- Doc: Now "See also" sections in the `man` pages are clickable (#69)
- Doc: Added "Manual" section to the manuals (#61)
- Build: Added `CentOS` container for `ci` testing (#38)
- Test: Tests are refactored. Added `clean` command tests, removed a lot of hard-coded things, moved tests execution from `./temp` folder to `/tmp`, added a lot of new check in old tests, and some new test cases (#52)
- Test: `shellcheck` is now supported with `make lint`

## Version 0.2.1

- Doc: Added `CONTRIBUTING.md` and `LICENSE.md`.
- Doc: New brand logo in the `README.md`.
- Build: Added autodeploy to `bintray` in `.travis.yml`.
- Test: Now everything is tested inside the `docker`-containers and `OSX` (MacOS) images on `travis`.
- Test: Added `.ci/` folder for continuous integration, refactored `utils/` folder.
- Test: Everything is `shellcheck`ed (except `tests/`).

## Version 0.2.0

- Feature: Added `changes` command to see the difference between current version of the hidden files and the committed one
- Feature: Added `-f` option to the `reveal` command to remove prompts
- Fix: Some bugs are fixed
- Doc: New installation instructions
- Build: Changed the way files were decrypted, now it is a separate function

## Version 0.1.2

- Feature: Added `-i` option to the `git-secret-add` command, which auto adds unignored files to the `.gitignore`
- Doc: `.github` templates added
- Doc: Documentation improved with `Configuration` section
- Build: `Makefile` improvements with `.PHONY` and `install` target
- Test: Added extra tests: for custom filenames and new features

## Version 0.1.1

- Feature: Added `--dry-run` option to the `git secret` command, which prevents any actions.
- Doc: Removed animation from docs, now using `asciinema.org`
- Test: `install_full_fixture()` returns a fingerprint
- Test: `uninstall_full_fixture()` receives two args
- Test: Fixed bug when tests were failing with `gpg2`
- Test: New travis strategy: testing both `gpg` and `gpg2`

## Version 0.1.0

- Feature: Initial release

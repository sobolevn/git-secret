# Changelog

## {{Next Version}}

### Features

- Support SECRETS_VERBOSE env var to enable verbosity (#323)
- Use gpg without --quiet when decrypting in verbose mode (#394)
- Add -v 'verbose' option to 'tell', showing gpg output (#320)
- Change 'init' to never ignore .secret files (#362)

### Bugfixes

- Update git-secret.io, fix utils/gh-branch.sh to use 'git all --add' (#344)
- Fix link to homebrew's git-secret in README.md (#310)
- Remove diagnostic output from test results (#324)
- Remove un-needed redirection in 'reveal' (#325)
- Remove unused functions from _git_secret_tools.sh
- Fix link to current contributors in CONTRIBUTING.md (#331)
- Fix tests when running from git hooks (#334)
- Fix typo, remove temp directory in utils/tests.sh (#347)
- Spelling fixes
- Fix re: SECRETS_DIR in 'init' and SECRETS_EXTENSION in test_reveal.bats (#364)
- Use SECRETS_GPG_COMMAND env var in gpg version check (#389)
- Add header to git-secret.7 man page, for debian and doc improvement (#386)

## Misc

- Use Shellcheck on tests/ files, changes for Shellcheck in tests/ (#368)
- Document SECRETS_VERBOSE and improve env var docs (#396)
- Update CHANGELOG.md to mention fix for #281 in v0.2.5 (#311)
- Add text explaining git-secret Style Guide and Development Philosophy
- Upgrade bats-core to v1.1.0, import bats-core into vendor/bats-core (#377)

## Version 0.2.5

### Features

- Add support for FreeBSD (#244)
- Add -l option to whoknows, which shows key expiration dates (#283)
- Add -P option (preserve permissions) to reveal and hide (#172)
- Add -F option (force, changing some errors to warnings) to hide and reveal (#253)
- Allow user to specify name of secret dir at runtime using SECRETS_DIR env var, and test (#247, #250)

### Bugfixes

- Fix issues with spaces in paths and filenames (#226, #135)
- Fix issue when 'hide' used in subdir of repo (#230)
- Fix issues in 'changes' with trailing newlines (#291)
- Fix 'hide' to only count actually hidden files as hidden (#280)
- Fixed bugs and improved error messages (#174)
- Issue error message when unable to hide a secret (#202, #238)
- Accept gpg key with no name, only an email (#227)
- Require keys to be specified by email, as documented (#267)
- Disallow 'git secret tell' or 'killperson' with emails that are not in keychain (also #267)

## Misc

- Added notes about packages and for package maintainers (#281)
- Improve documentation regarding operation with different versions of GPG (#274, #182)
- Documentation improvements, error message and text improvements, and typo fixes (#254)
- git-secret RFC#001 added, documenting a path towards independence from gpg binary formats (#208)
- Add tests for expired gpg keys, and gpg keys with only emails (#276)

## Version 0.2.4

### Features

- Added `git secret cat` feature (#141)

### Bugfixes

- `git secret hide` and `git secret changes` check for files more carefully (#153, #154)

### Misc

- Documentation and error message improvements (#126, #136, #144, #150)
- Build and CI fixes (#152, #179, #186, #188, #189)
- Migrate to `bats-core` bash testing framework

## Version 0.2.3

### Features

- Added `-m` option to `hide` command, files will only be hidden when modifications are detected (#92)
- Changed how path mappings file works: colon delimited FSDB (#92)
- `git secret init` now adds `random_seed` to `.gitignore` (#93)

### Bugfixes

- Dropped `git check-ignore`, using `git add --dry-run` instead to check for ignored files (#105,#38)
- Fixed `gnupg` >= 2.1 CI tests (#6)

### Misc

- Now users can run local CI tests using test-kitchen (#6)
- Migrated travis ci tests to test-kitchen for Linux platforms.
- Added more `gpg` version to test matrix (#99)
- Added CentOS to test matrix (#38,#91)
- All tested Linux platforms now use latest release of `shellcheck`
- Added Alpine to test matrix, and apk is now built. (#75)

## Version 0.2.2

### Features

- Change how the `usage` command works (#48)
- Now `git-secret` works from any place inside `git-tree` (#56)
- Added `-d` option to the `hide` command: it deletes unencrypted files (#62)
- Added new command `changes` to see the diff between the secret files (#64)
- Now it is possible to provide multiple emails to the `killperson` command (#73)
- Now it is possible to provide multiple emails to the `tell` command (#72)

### Bugfixes

- Fixed bug when `_user_required` was not working after re-importing keys (#74)
- Refactored `hide` and `clean` commands to be shorter

### Misc

- Now every doc in this project refer to `git-secret.io` instead of old `gh-pages` website (#71)
- Now installation section is removed from main `man` file (#70)
- Now "See also" sections in the `man` pages are clickable (#69)
- Added "Manual" section to the manuals (#61)
- Added `CentOS` container for `ci` testing (#38)
- Tests are refactored. Added `clean` command tests, removed a lot of hard-coded things, moved tests execution from `./temp` folder to `/tmp`, added a lot of new check in old tests, and some new test cases (#52)
- `shellcheck` is now supported with `make lint`

## Version 0.2.1

### Misc

- Added `CONTRIBUTING.md` and `LICENSE.md`.
- New brand logo in the `README.md`.
- Added autodeploy to `bintray` in `.travis.yml`.
- Now everything is tested inside the `docker`-containers and `OSX` (MacOS) images on `travis`.
- Added `.ci/` folder for continuous integration, refactored `utils/` folder.
- Everything is `shellcheck`ed (except `tests/`).

## Version 0.2.0

### Features

- Added `changes` command to see the difference between current version of the hidden files and the committed one
- Added `-f` option to the `reveal` command to remove prompts

### Bugfixes

- Some bugs are fixed

### Misc

- New installation instructions
- Changed the way files were decrypted, now it is a separate function

## Version 0.1.2

### Features

- Added `-i` option to the `git-secret-add` command, which auto adds unignored files to the `.gitignore`

### Misc

- `.github` templates added
- Documentation improved with `Configuration` section
- `Makefile` improvements with `.PHONY` and `install` target
- Added extra tests: for custom filenames and new features

## Version 0.1.1

### Features

- Added `--dry-run` option to the `git secret` command, which prevents any actions.

### Misc

- Removed animation from docs, now using `asciinema.org`
- `install_full_fixture()` returns a fingerprint
- `uninstall_full_fixture()` receives two args
- Fixed bug when tests were failing with `gpg2`
- New travis strategy: testing both `gpg` and `gpg2`

## Version 0.1.0

### Features

- Implementation of git secret add
- Implementation of git secret clean, with -v option
- Implementation of git secret hide, with -c 'clean' and -v option
- Implementation of git secret init
- Implementation of git secret killperson
- Implementation of git secret list
- Implementation of git secret remove, with -c option
- Implementation of git secret reveal, with -d homedir and -p passphrase options
- Implementation of git secret tell, with -m email and -d homedir options
- Implementation of git secret usage

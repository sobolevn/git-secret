# Changelog

## Version 0.1.1

- Added `--dry-run` option to the `git secret` command, which prevents any actions.
- Now `install_full_fixture()` returns a fingerprint
- Now `uninstall_full_fixture()` receives two args
- Fixed bug, when tests were failing with `gpg2`
- New travis strategy: testing both `gpg` and `gpg2`
- Removed animation from docs, now using `asciinema.org`

## Version 0.1.0

- Initial release

README for git-secret/vendor directory

We import bats-core v1.3.0 here for
https://github.com/sobolevn/git-secret/issues/377,
"Don't depend on network during builds (re: bats-core)"

If you want upgrade bats-core, replace the files in vendor/bats-core.
They must remain exactly as distributed by the chosen release of bats-core
- see issue linked above for details.


## Changes:

- 2021-05-03: Version update from `bats-core@1.1.0` to `bats-core@1.3.0`
- Initial import of `bats-core@1.1.0`

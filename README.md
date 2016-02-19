# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret)

## Status

This project is still under development. Current objectives:

- check all exit codes, modify if needed
- add check if the `.gitsecret` folder is ignored, raise exception in that case.
- add `trust-model` parameter to `git-secret-hide`
- add exception when running `git secret hide` with no files added
- manuals
- hooks: `pre-commit` to encrypt secret files
- static site for `gh-pages` build from manuals with `Jekyll` and `Ronn`
- plugin for `zsh`
- extra tests
- precompiled distributions for `brew` and other package managers
- styleguide for bash (?)
- сygwin support (?)


## Requirements

`git-secret` works only with `git` and `gpg`, it is tested and works for Mac OS X, Ubuntu and Debian.
No other dependencies are required.


## Testing

For testing this project uses [`bats`](1). You can install it by running `make install-test`.
To run tests call: `make test`. It will download and install `bats` into `vandor/bats` if it's not installed yet.


## Installation

Right now installation is only possible with this workflow:

1. `git clone https://github.com/sobolevn/git-secret.git`
2. `make develop`
3. then move the resulting file `git-secret` somewhere inside your `PATH`


[1]: https://github.com/sstephenson/bats

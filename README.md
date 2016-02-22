# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret)

## Status

This project is still under development. Current objectives:

- add `trust-model` parameter to `git-secret-hide`
- hooks: `pre-commit` to encrypt secret files
- static site for `gh-pages` build from manuals with `Jekyll` and `Ronn`
- autocomplete for `zsh` plugin
- extra tests
- precompiled distributions for `brew` and other package managers
- create `CONTRIBUTING.md` with custom styleguide, refactor code due to styleguide
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

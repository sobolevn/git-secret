# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret)

## Preview

![git-secret terminal preview](https://raw.githubusercontent.com/sobolevn/git-secret/gh-pages/images/gitsecret_terminal.gif)

## Installation and Usage

See the [git-secret site](https://sobolevn.github.io/git-secret/).

## Status

This project is still under development. Current objectives:

- add `trust-model` parameter to `git-secret-hide`
- autocomplete for `zsh` plugin
- extra tests
- precompiled distributions for `brew` and other package managers
- create `CONTRIBUTING.md` with custom styleguide, refactor code due to styleguide
- сygwin support (?)


## Testing

For testing this project uses [`bats`](1). You can install it by running `make install-test`.
To run tests call: `make test`. It will download and install `bats` into `vendor/bats` if it's not installed yet.


[1]: https://github.com/sstephenson/bats

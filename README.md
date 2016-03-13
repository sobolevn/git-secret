# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret)

## Preview

![git-secret terminal preview](https://raw.githubusercontent.com/sobolevn/git-secret/gh-pages/images/gitsecret_terminal.gif)

## Usage

See the [git-secret site](https://sobolevn.github.io/git-secret/).

## Installation

See the [installation section](https://sobolevn.github.io/git-secret/#installation).

## Status

This project is still under development. Current objectives:

- add `trust-model` parameter to `git-secret-hide`
- autocomplete for `zsh` plugin
- extra tests
- precompiled distribution for `RPM`
- integrate [`shellcheck`](https://github.com/koalaman/shellcheck) for code style tests
- create `CONTRIBUTING.md` with development process explained
- сygwin support (?)

## Testing

For testing this project uses [`bats`](https://github.com/sstephenson/bats). You can install it by running `make install-test`.
To run tests call: `make test`. It will download and install `bats` into `vendor/bats` if it's not installed yet.


## Changelog

### Version 0.1.0

- Initial release

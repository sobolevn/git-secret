# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret)

## Status

This project is still under development. Current objectives:

- manuals
- static site fot `gh-pages` build from manuals with `Jekyll` and `Ronn`
- plugin for `zsh`
- extra tests
- precompiled distributions for `brew` and other package managers
- сygwin support (?)


## Requirements

`git-secret` works only with `git` and `gpg`, it is tested and works for Mac OS X, Ubuntu and Debian.
No other dependencies are required.

For testing it uses `bats`. You can install it by running `make install-test`.


## Installation

Right now installation is only possible with this workflow:

1. `git clone https://github.com/sobolevn/git-secret.git`
2. `make develop`
3. then move the resulting file `git-secret` somewhere inside your `PATH`

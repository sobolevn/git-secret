---
layout: post
title:  'git-secret-changes'
date:   2016-08-21 16:36:33 +0300
permalink: git-secret-changes
categories: command
---
git-secret-changes - view diff of the hidden files.
===================================================

## SYNOPSIS

    git secret changes [-h] [-d dir] [-p password] <pathspec>...


## DESCRIPTION
`git-secret-changes` - shows changes between the current version of hidden files and the ones already commited.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`, basically use this option if your store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## SEE ALSO

git-secret-add(1), git-secret-tell(1), git-secret-hide(1), git-secret-reveal(1)

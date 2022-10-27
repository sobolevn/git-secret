---
layout: post
title: 'git-secret-cat'
date: 2022-10-27 17:51:47 +0000
permalink: git-secret-cat
categories: command
---
git-secret-cat - decrypts files passed on command line to stdout.
=============================================

## SYNOPSIS

    git secret cat [-d dir] [-p password] filename [filenames]


## DESCRIPTION
`git-secret-cat` - prints the decrypted contents of the passed files.

As with `git-secret-reveal`, you'll need to have the private key for one of the emails allowed to
decrypt this repo in your personal keyring.

Note this command can be affected by the `SECRETS_PINENTRY` environment variable. See
(See [git-secret(7)](https://git-secret.io/git-secret) for information using `SECRETS_PINENTRY`.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`, use this option if you store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## MANUAL

Run `man git-secret-cat` to see this document.


## SEE ALSO

[git-secret-init(1)](https://git-secret.io/git-secret-init), [git-secret-tell(1)](https://git-secret.io/git-secret-tell), [git-secret-add(1)](https://git-secret.io/git-secret-add), [git-secret-hide(1)](https://git-secret.io/git-secret-hide), [git-secret-reveal(1)](https://git-secret.io/git-secret-cat)

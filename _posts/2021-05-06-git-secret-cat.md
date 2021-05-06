---
layout: post
title:  'git-secret-cat'
date:   2021-05-06 12:20:09 +0000
permalink: git-secret-cat
categories: command
---
git-secret-cat - decrypts files passed on command line to stdout
=============================================

## SYNOPSIS

    git secret cat [-d dir] [-p password] filename [filenames]


## DESCRIPTION
`git-secret-cat` - Outputs to stdout the contents of the files named on the command line.
As with `git-secret-reveal`, you'll need to have a public/private keypair that is allowed to 
decrypt this repo.

Note also that this command can be affected by the `SECRETS_PINENTRY` environment variable. See
(See [git-secret(7)](http://git-secret.io/git-secret) for information using `SECRETS_PINENTRY`.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`, basically use this option if you store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## MANUAL

Run `man git-secret-cat` to see this note.


## SEE ALSO

[git-secret-init(1)](http://git-secret.io/git-secret-init), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-add(1)](http://git-secret.io/git-secret-add), [git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-cat)

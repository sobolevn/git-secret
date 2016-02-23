---
layout: post
title:  'git-secret-reveal'
date:   2016-02-24 00:52:07 +0300
categories: command
---
git-secret-reveal - decrypts all added files.
=============================================

## SYNOPSIS

    git secret reveal [-d dir] [-p password]


## DESCRIPTION
`git-secret-reveal` - decrypts all the files in the `.gitsecret/paths/mapping.cfg` by running a `gpg --decrypt` command. It is important to have paired secret-key for one of the public-keys, which were used in the encryption.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`, basically use this option if your store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## SEE ALSO

git-secret-init(1), git-secret-tell(1), git-secret-add(1), git-secret-hide(1)

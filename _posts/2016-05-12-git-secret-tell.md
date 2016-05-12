---
layout: post
title:  'git-secret-tell'
date:   2016-05-12 14:25:04 +0300
categories: command
---
git-secret-tell - adds a person, who can access private data.
===============================================================

## SYNOPSIS

    git secret tell [-m] [-d dir] [email]


## DESCRIPTION
`git-secret-tell` receives an email address as an input, searches for the `gpg`-key in the `gpg`'s `homedir` by this email, then imports a person's public key into the `git-secret`'s inner keychain. From this moment this person can encrypt new files with the keyring which contains their key. But they cannot decrypt the old files, which were already encrypted without their key. They should be reencrypted with the new keyring by someone, who has the unencrypted files.

**Do not manually import secret key into `git-secret`**. Anyways, it won't work with any of the secret-keys imported.


## OPTIONS

    -m  - takes your current `git config user.email` as an identifier for the key.
    -d  - specifies `--homedir` option for the `gpg`, basically use this option if your store your keys in a custom location.
    -h  - shows help.


## SEE ALSO

git-secret-init(1), git-secret-add(1), git-secret-hide(1), git-secret-reveal(1)

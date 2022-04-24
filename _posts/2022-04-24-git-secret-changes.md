---
layout: post
title: 'git-secret-changes'
date: 2022-04-24 14:23:27 +0000
permalink: git-secret-changes
categories: command
---
git-secret-changes - view diff of the hidden files.
===================================================

## SYNOPSIS

    git secret changes [-h] [-d dir] [-p password] [pathspec]...


## DESCRIPTION
`git-secret-changes` - shows changes between the current versions of secret files and encrypted versions.

If no filenames are provided, changes to all hidden files will be shown. Alternately,
provide any number of hidden files to this command as arguments, and it will show changes for those files.

Note files must be specified by their unencrypted names, without the `.secret` suffix,
(or whatever is specified by the `SECRETS_EXTENSION` environment variable).

Note also this command can be affected by the `SECRETS_PINENTRY` environment variable. See
(See [git-secret(7)](https://git-secret.io/git-secret) for information using `SECRETS_PINENTRY`.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`. Use this option if your store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## MANUAL

Run `man git-secret-changes` to see this document.


## SEE ALSO

[git-secret-add(1)](https://git-secret.io/git-secret-add), [git-secret-tell(1)](https://git-secret.io/git-secret-tell),
[git-secret-hide(1)](https://git-secret.io/git-secret-hide), [git-secret-reveal(1)](https://git-secret.io/git-secret-reveal),
[git-secret-cat(1)](https://git-secret.io/git-secret-cat)

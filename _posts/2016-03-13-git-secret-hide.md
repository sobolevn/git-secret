---
layout: post
title:  'git-secret-hide'
date:   2016-03-13 13:15:10 +0300
categories: command
---
git-secret-hide - encrypts all added files with the inner keyring.
==================================================================

## SYNOPSIS

    git secret hide [-c] [-v]


## DESCRIPTION
`git-secret-hide` create an encrypted version for each file added by `git-secret-add` command. Now anyone from the `git-secret`'s keyring can decrypt these files using their secret key.

It is possible to modify the names of the encrypted files by setting `SECRETS_EXTENSION` variable.


## OPTIONS

    -v  - verbose, shows extra information.
    -c  - deletes encrypted files before creating new ones.
    -h  - shows help.


## SEE ALSO

git-secret-init(1), git-secret-tell(1), git-secret-add(1), git-secret-reveal(1)

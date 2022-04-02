---
layout: post
title: 'git-secret-clean'
date: 2022-04-02 15:17:03 +0000
permalink: git-secret-clean
categories: command
---
git-secret-clean - removes all the hidden files.
================================================

## SYNOPSIS

    git secret clean [-v]


## DESCRIPTION
`git-secret-clean` deletes all the encrypted files.
Verbose output is enabled with the `-v` option, in which case the program prints which files are deleted.


## OPTIONS

    -v  - verbose mode, shows which files are deleted.
    -h  - shows this help.

You can also enable verbosity using the SECRETS_VERBOSE environment variable,
as documented at [git-secret(7)](https://git-secret.io/)

## MANUAL

Run `man git-secret-clean` to see this note.


## SEE ALSO

[git-secret-whoknows(1)](https://git-secret.io/git-secret-whoknows), [git-secret-add(1)](https://git-secret.io/git-secret-add),
[git-secret-remove(1)](https://git-secret.io/git-secret-remove), [git-secret-removeperson(1)](https://git-secret.io/git-secret-removeperson)

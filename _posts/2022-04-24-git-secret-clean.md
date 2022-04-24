---
layout: post
title: 'git-secret-clean'
date: 2022-04-24 14:09:32 +0000
permalink: git-secret-clean
categories: command
---
git-secret-clean - removes all the hidden files.
================================================

## SYNOPSIS

    git secret clean [-v]


## DESCRIPTION
`git-secret-clean` - deletes all files in the current `git-secret` repo that end with `.secret`.

You can change the extension `git-secret` uses for encrypted files
with the `SECRETS_EXTENSION` environment variable.

Note that it will delete any files ending in `.secret`, even if they are not tracked by `git-secret`. 

Also note that this command does not delete unencrypted versions of files.

Verbose mode, enabled with the `-v` option, displays the filenames deleted.


## OPTIONS

    -v  - verbose mode, shows which files are deleted.
    -h  - shows this help.

You can also enable verbosity using the SECRETS_VERBOSE environment variable,
as documented at [git-secret(7)](https://git-secret.io/)

## MANUAL

Run `man git-secret-clean` to see this document.


## SEE ALSO

[git-secret-whoknows(1)](https://git-secret.io/git-secret-whoknows), [git-secret-add(1)](https://git-secret.io/git-secret-add),
[git-secret-remove(1)](https://git-secret.io/git-secret-remove), [git-secret-removeperson(1)](https://git-secret.io/git-secret-removeperson)

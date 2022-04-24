---
layout: post
title: 'git-secret-remove'
date: 2022-04-24 13:52:13 +0000
permalink: git-secret-remove
categories: command
---
git-secret-remove - removes files from index.
=============================================

## SYNOPSIS

    git secret remove [-c] <pathspec>...


## DESCRIPTION
`git-secret-remove` - stops files from being tracked by `git-secret`.

This deletes filenames from `.gitsecret/paths/mapping.cfg`, 
which stops these files from being tracked by `git-secret`, and from
being encrypted to, or decrypted from, `.secret` encrypted versions.

There's also a -c option to delete existing encrypted versions of the files provided.

Note unlike `add`, which automatically add pathnames to `.gitignore`, 
`remove` does not delete pathnames from `.gitignore`.

(See [git-secret(7)](https://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the `SECRETS_DIR` environment variable.


## OPTIONS

    -c  - deletes existing real encrypted files.
    -h  - shows help.


## MANUAL

Run `man git-secret-remove` to see this document.


## SEE ALSO

[git-secret-add(1)](https://git-secret.io/git-secret-add), [git-secret-clean(1)](https://git-secret.io/git-secret-clean),
[git-secret-removeperson(1)](https://git-secret.io/git-secret-removeperson)

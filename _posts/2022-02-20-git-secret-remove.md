---
layout: post
title: 'git-secret-remove'
date: 2022-02-20 15:39:56 +0000
permalink: git-secret-remove
categories: command
---
git-secret-remove - removes files from index.
=============================================

## SYNOPSIS

    git secret remove [-c] <pathspec>...


## DESCRIPTION
`git-secret-remove` deletes files from `.gitsecret/paths/mapping.cfg`,
so they won't be encrypted or decrypted in the future.
There's also a -c option to delete existing encrypted versions of the files provided.

(See [git-secret(7)](https://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the `SECRETS_DIR` environment variable.


## OPTIONS

    -c  - deletes existing real encrypted files.
    -h  - shows help.


## MANUAL

Run `man git-secret-remove` to see this note.


## SEE ALSO

[git-secret-add(1)](https://git-secret.io/git-secret-add), [git-secret-clean(1)](https://git-secret.io/git-secret-clean),
[git-secret-removeperson(1)](https://git-secret.io/git-secret-removeperson)

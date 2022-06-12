---
layout: post
title: 'git-secret-list'
date: 2022-06-12 13:55:10 +0000
permalink: git-secret-list
categories: command
---
git-secret-list - prints all the added files.
=============================================

## SYNOPSIS

    git secret list


## DESCRIPTION
`git-secret-list` - print the files currently considered secret in this repo.

Shows tracked files from `.gitsecret/paths/mapping.cfg`.

(See [git-secret(7)](https://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the `SECRETS_DIR` environment variable.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-list` to see this document.


## SEE ALSO

[git-secret-whoknows(1)](https://git-secret.io/git-secret-whoknows), [git-secret-add(1)](https://git-secret.io/git-secret-add),
[git-secret-remove(1)](https://git-secret.io/git-secret-remove), [git-secret-hide(1)](https://git-secret.io/git-secret-hide),
[git-secret-reveal(1)](https://git-secret.io/git-secret-reveal), [git-secret-cat(1)](https://git-secret.io/git-secret-cat)

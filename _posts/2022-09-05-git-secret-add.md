---
layout: post
title: 'git-secret-add'
date: 2022-09-05 22:52:09 +0000
permalink: git-secret-add
categories: command
---
git-secret-add - starts to track added files.
=============================================

## SYNOPSIS

    git secret add [-v] [-i] <pathspec>...


## DESCRIPTION
`git secret add` - tells `git secret` which files hold secrets.

Adds filepath(s) into `.gitsecret/paths/mapping.cfg`.
(It is not recommended to alter `.gitsecret/paths/mapping.cfg` manually.)

As of 0.2.6, this command also ensures the filepath is in `.gitignore`
as the contents are now considered secret and should not be committed into the repository unencrypted.

The `add` action will fail unless there are already users in `git-secret`'s keyring.


(See [git-secret(7)](https://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the SECRETS_DIR environment variable.

## OPTIONS

    -v  - verbose, shows extra information.
    -i  - does nothing, adding paths to .gitignore is now the default behavior.
    -h  - shows this help.


## MANUAL

Run `man git-secret-add` to see this document.


## SEE ALSO

[git-secret-init(1)](https://git-secret.io/git-secret-init), [git-secret-tell(1)](https://git-secret.io/git-secret-tell),
[git-secret-hide(1)](https://git-secret.io/git-secret-hide), [git-secret-reveal(1)](https://git-secret.io/git-secret-reveal)

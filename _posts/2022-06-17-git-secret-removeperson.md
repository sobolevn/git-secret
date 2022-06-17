---
layout: post
title: 'git-secret-removeperson'
date: 2022-06-17 18:35:07 +0000
permalink: git-secret-removeperson
categories: command
---
git-secret-removeperson - removes user's public key from repo keyring.
==================================================================================

## SYNOPSIS

    git secret removeperson <emails>...


## DESCRIPTION
`git-secret-removeperson` - removes public keys for passed email addresses from repo's `git-secret` keyring.

This command is used to begin the process of disallowing a user from encrypting and decrypting secrets with `git-secret`.

If you remove a user's access with `git-secret-removeperson`, and then run `git-secret-reveal` and `git-secret-hide -r`,
that user will no longer be able user to decrypt the hidden files.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-removeperson` to see this document.


## SEE ALSO

[git-secret-tell(1)](https://git-secret.io/git-secret-tell), [git-secret-remove(1)](https://git-secret.io/git-secret-remove),
[git-secret-clean(1)](https://git-secret.io/git-secret-clean)

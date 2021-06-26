---
layout: post
title: 'git-secret-removeperson'
date: 2021-06-26 14:36:18 +0000
permalink: git-secret-removeperson
categories: command
---
git-secret-removeperson - deletes key identified by an email from the inner keyring.
==================================================================================

## SYNOPSIS

    git secret removeperson <emails>...


## DESCRIPTION
This command removes the keys associated with the selected email addresses from the keyring.
If you remove a keypair's access with `git-secret-removeperson`, and run `git-secret-reveal` and `git-secret-hide -r`,
it will be impossible for given users to decrypt the hidden files.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-removeperson` to see this note.


## SEE ALSO

[git-secret-tell(1)](https://git-secret.io/git-secret-tell), [git-secret-remove(1)](https://git-secret.io/git-secret-remove),
[git-secret-clean(1)](https://git-secret.io/git-secret-clean)

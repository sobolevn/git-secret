---
layout: post
title:  'git-secret-killperson'
date:   2017-02-26 18:27:18 +0300
permalink: git-secret-killperson
categories: command
---
git-secret-killperson - deletes key identified by an email from the inner keyring.
==================================================================================

## SYNOPSIS

    git secret killperson <emails>...


## DESCRIPTION
This command removes selected email addresses from the keyring. `git-secret-killperson` makes it impossible for given users to decrypt the hidden files in the future. It is required to run `git-secret-hide` once again with the updated keyring to renew the encryption.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-killperson` to see this note.


## SEE ALSO

[git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-remove(1)](http://git-secret.io/git-secret-remove), [git-secret-clean(1)](http://git-secret.io/git-secret-clean)

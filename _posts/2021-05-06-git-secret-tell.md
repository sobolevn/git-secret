---
layout: post
title:  'git-secret-tell'
date:   2021-05-06 08:36:03 +0000
permalink: git-secret-tell
categories: command
---
git-secret-tell - adds a person, who can access private data.
===============================================================

## SYNOPSIS

    git secret tell [-m] [-d dir] [emails]...


## DESCRIPTION
`git-secret tell` receives one or more email addresses as an input, searches for the `gpg`-key in the `gpg`
`homedir` by these emails, then imports the corresponding public key into `git-secret`'s inner keychain. 
From this moment this person can encrypt new files with the keyring which contains their key,
but they cannot decrypt the old files, which were already encrypted without their key. 
The files should be re-encrypted with the new keyring by someone who has the unencrypted files.

Because `git-secret tell` works with only email addresses, it will exit with an error if you have
multiple keys in your keychain with specified email addresses, or if one of the specified emails 
is already associated with a key in the git-secret keychain.

Versions of `git-secret tell` after 0.3.2 will warn about keys that are expired, revoked, or otherwise invalid,
and also if multiple keys are found for a single email address.

**Do not manually import secret keys into `git-secret`**. It won't work with imported secret keys anyway.

## OPTIONS

    -m  - takes your current `git config user.email` as an identifier for the key.
    -d  - specifies `--homedir` option for the `gpg`, basically use this option if your store your keys in a custom location.
    -h  - shows help.


## MANUAL

Run `man git-secret-tell` to see this note.


## SEE ALSO

[git-secret-init(1)](http://git-secret.io/git-secret-init), [git-secret-add(1)](http://git-secret.io/git-secret-add), 
[git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal), 
[git-secret-cat(1)](http://git-secret.io/git-secret-cat), [git-secret-killperson(1)](http://git-secret.io/git-secret-killperson)

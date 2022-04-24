---
layout: post
title: 'git-secret-tell'
date: 2022-04-24 13:48:48 +0000
permalink: git-secret-tell
categories: command
---
git-secret-tell - adds person who can access private data.
===============================================================

## SYNOPSIS

    git secret tell [-m] [-d dir] [emails]...


## DESCRIPTION
`git-secret tell` - adds user(s) to the list of those able to encypt/decrypt secrets.

This lets the specified user encrypt new files,
but will not immediately be able to decrypt existing files, which were encrypted without their key.
Files should be re-encrypted with the new keyring by someone who already has access
in order for the new user to be able to decrypt the files.

`git-secret tell` works only with email addresses, and will exit with an error if you have
multiple keys in your keyring with specified email addresses, or if one of the specified emails
is already associated with a key in the `git-secret` repo's keyring.

Under the hood, `git-secret-tell` searches in the current user's `gnupg` keyring for public key(s) of passed
email(s), then imports the corresponding public key(s) into your `git-secret` repo's keyring.

Versions of `git-secret tell` after `0.3.2` will warn about keys that are expired, revoked, or otherwise invalid.
It will also warn if multiple keys are found for a single email address.

**Do not manually import secret keys into `git-secret`**. It won't work with imported secret keys anyway.

For more details about how `git-secret` uses public and private keys,
see the documentation for `git-secret-hide` and `git-secret-reveal`.

## OPTIONS

    -m  - uses your current `git config user.email` setting as an identifier for the key.
    -d  - specifies `--homedir` option for `gpg`, basically use this option if your store your keys in a custom location.
    -h  - shows help.


## MANUAL

Run `man git-secret-tell` to see this document.


## SEE ALSO

[git-secret-init(1)](https://git-secret.io/git-secret-init), [git-secret-add(1)](https://git-secret.io/git-secret-add),
[git-secret-hide(1)](https://git-secret.io/git-secret-hide), [git-secret-reveal(1)](https://git-secret.io/git-secret-reveal),
[git-secret-cat(1)](https://git-secret.io/git-secret-cat), [git-secret-removeperson(1)](https://git-secret.io/git-secret-removeperson)

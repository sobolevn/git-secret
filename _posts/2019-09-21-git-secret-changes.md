---
layout: post
title:  'git-secret-changes'
date:   2019-09-21 09:21:11 -0400
permalink: git-secret-changes
categories: command
---
git-secret-changes - view diff of the hidden files.
===================================================

## SYNOPSIS

    git secret changes [-h] [-d dir] [-p password] [pathspec]...


## DESCRIPTION
`git-secret-changes` - shows changes between the current version of hidden files and the ones already committed. 
You can provide any number of hidden files to this command as arguments, and it will show changes for these files only. 
Note that files must be specified by their encrypted names, typically `filename.yml.secret`.
If no arguments are provided, information about all hidden files will be shown.

Note also that this command can be affected by the `SECRETS_PINENTRY` environment variable. See
(See [git-secret(7)](http://git-secret.io/git-secret) for information using `SECRETS_PINENTRY`.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`. Use this option if your store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## MANUAL

Run `man git-secret-changes` to see this note.


## SEE ALSO

[git-secret-add(1)](http://git-secret.io/git-secret-add), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), 
[git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal), 
[git-secret-cat(1)](http://git-secret.io/git-secret-cat)

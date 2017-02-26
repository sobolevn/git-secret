---
layout: post
title:  'git-secret-changes'
date:   2017-02-26 18:27:18 +0300
permalink: git-secret-changes
categories: command
---
git-secret-changes - view diff of the hidden files.
===================================================

## SYNOPSIS

    git secret changes [-h] [-d dir] [-p password] [pathspec]...


## DESCRIPTION
`git-secret-changes` - shows changes between the current version of hidden files and the ones already commited. You can provide any number of files to this command as arguments, so it will show changes for these files only. If no arguments are provided - information about all files will be shown.


## OPTIONS

    -d  - specifies `--homedir` option for the `gpg`, basically use this option if your store your keys in a custom location.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -h  - shows help.


## MANUAL

Run `man git-secret-changes` to see this note.


## SEE ALSO

[git-secret-add(1)](http://git-secret.io/git-secret-add), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal)

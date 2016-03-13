---
layout: post
title:  'git-secret-add'
date:   2016-03-13 13:15:10 +0300
categories: command
---
git-secret-add - starts to track added files.
=============================================

## SYNOPSIS

    git secret add <pathspec>...


## DESCRIPTION
`git-secret-add` adds a filepath(es) into the `.gitsecret/paths/mapping.cfg`. When adding files, ensure that they are ignored by `git`, since they must be secure and not be commited into the remote repository unencrypted.

If there's no users in the `git-secret`'s keyring, when adding a file, an exception will be raised.

It is not recommened to add filenames directly into the `.gitsecret/paths/mapping.cfg`, use the command.


## OPTIONS

    -h  - shows this help.


## SEE ALSO

git-secret-init(1), git-secret-tell(1), git-secret-hide(1), git-secret-reveal(1)

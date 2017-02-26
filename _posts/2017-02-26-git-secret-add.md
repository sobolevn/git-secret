---
layout: post
title:  'git-secret-add'
date:   2017-02-26 18:27:18 +0300
permalink: git-secret-add
categories: command
---
git-secret-add - starts to track added files.
=============================================

## SYNOPSIS

    git secret add [-i] <pathspec>...


## DESCRIPTION
`git-secret-add` adds a filepath(es) into the `.gitsecret/paths/mapping.cfg`. When adding files, ensure that they are ignored by `git`, since they must be secure and not be commited into the remote repository unencrypted.

If there's no users in the `git-secret`'s keyring, when adding a file, an exception will be raised.

It is not recommened to add filenames directly into the `.gitsecret/paths/mapping.cfg`, use the command.


## OPTIONS

    -i  - auto adds given files to the `.gitignore` if they are unignored at the moment.
    -h  - shows this help.


## MANUAL

Run `man git-secret-add` to see this note.


## SEE ALSO

[git-secret-init(1)](http://git-secret.io/git-secret-init), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal)

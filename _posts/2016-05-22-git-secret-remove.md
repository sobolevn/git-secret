---
layout: post
title:  'git-secret-remove'
date:   2016-05-22 00:07:28 +0300
categories: command
---
git-secret-remove - removes files from index.
=============================================

## SYNOPSIS

    git secret remove [-c] <pathspec..>


## DESCRIPTION
`git-secret-remove` deletes files from `.gitsecret/paths/mapping.cfg`, so they won't be encrypted or decrypted in the future. There's also an option to delete existing encrypted versions of the files provided.


## OPTIONS

    -c  - deletes existing real encrypted files.
    -h  - shows help.


## SEE ALSO

git-secret-add(1), git-secret-reveal(1), git-secret-hide(1)

---
layout: post
title:  'git-secret-killperson'
date:   2016-05-29 13:46:34 +0300
categories: command
---
git-secret-killperson - deletes key identified by an email from the inner keyring.
==================================================================================

## SYNOPSIS

    git secret killperson [email]


## DESCRIPTION
`git-secret-killperson` makes it impossible for given user to decrypt the hidden file in the future. It is required to run `git-secret-hide` once again with the updated keyring.


## OPTIONS

    -h  - shows this help.


## SEE ALSO

git-secret-tell(1), git-secret-hide(1), git-secret-reveal(1)

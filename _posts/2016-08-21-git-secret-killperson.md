---
layout: post
title:  'git-secret-killperson'
date:   2016-08-21 16:36:33 +0300
permalink: git-secret-killperson
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

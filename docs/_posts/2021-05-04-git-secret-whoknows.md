---
layout: post
title:  'git-secret-whoknows'
date:   2021-05-04 12:15:29 +0300
permalink: git-secret-whoknows
categories: command
---
git-secret-whoknows - prints email-labels for each key in the keyring.
======================================================================

## SYNOPSIS

    git secret whoknows


## DESCRIPTION
`git-secret-whoknows` prints list of email addresses whose keys are allowed to access the secrets in this repo.


## OPTIONS

    -l  - 'long' output, shows key expiration dates.
    -h  - shows this help.


## MANUAL

Run `man git-secret-whoknows` to see this note.


## SEE ALSO

[git-secret-list(1)](http://git-secret.io/git-secret-list), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), 
[git-secret-hide(1)](http://git-secret.io/git-secret-hide), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal), 
[git-secret-cat(1)](http://git-secret.io/git-secret-cat)

---
layout: post
title:  'git-secret-killperson'
date:   2021-05-08 18:01:39 +0000
permalink: git-secret-killperson
categories: command
---
git-secret-killperson - deletes key identified by an email from the inner keyring.
==================================================================================

## SYNOPSIS

    git secret killperson <emails>...


## DESCRIPTION
This command removes the keys associated with the selected email addresses from the keyring. 
If you remove a keypair's access with `git-secret-killperson`, and run `git-secret-reveal` and `git-secret-hide -r`,
it will be impossible for given users to decrypt the hidden files.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-killperson` to see this note.


## SEE ALSO

[git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-remove(1)](http://git-secret.io/git-secret-remove),
[git-secret-clean(1)](http://git-secret.io/git-secret-clean)

---
layout: post
title:  'git-secret'
date:   2016-02-24 00:54:31 +0300
categories: usage
---
## Intro

There's a known problem in server configuration and deploying, when you have to store your private data such as: database passwords, application secret-keys, OAuth secret keys and so on, outside of the git repository. Even if this repository is private, it is a security risk to just publish them into the world wide web. What are the drawbacks of storing them separately?

1. These files are not version controlled. Filenames change, locations change, passwords change from time to time, some new information appears, other is removed. And you can not tell for sure which version of the configuration file was used with each commit.
2. When building the automated deploing system there will be one extra step: download and place these secret-configuration files where it needs to be. So you have to maintain an extra secure location, where everything is stored.

### How does `git-secret` solves these problems?
1. `git-secret` encrypts files and stores them inside the `git` repository, so you will have all the changes for every commit.
2. `git-secret` doesn't require any other deploy operations rather than `git secret reveal`, so it will automatically decrypt all the required files.

### What is `git-secret`?
`git-secret` is a bash tool to store your private data inside a `git` repo. How's that? Basically, it just encrypts, using `gpg`, the tracked files with the public keys of all the users that you trust. So everyone of them can decrypt these files using only their personal secret key. Why to deal with all these private-public keys stuff? Well, to make it easier for everyone to manage access rights. There are no passwords that change. When someone is out - just delete his public key, reencrypt the files, and he won't be able to decrypt secrets anymore.

## Installation

### Dependencies

`git secret` relies on two dependecies: [`git`][1] and [`gpg`][2]. Download and install them before using this project. `git-secret` is tested to work with:

    git version 2.7.0
    gpg (GnuPG) 1.4.20

### Supported platforms

`git secret` works with `Mac OS X` >= 10.9, `Ubuntu` >= 14.04 and `Debian` >= 8.3
You can add you platform to this list, if all the tests passes for you.
`Cygwin` support is planned.

### Installation process

There are several ways to install `git-secret`:

**The hard way**

1. Clone the repository first: `git clone https://github.com/sobolevn/git-secret.git git-secret`
2. Run `cd git-secret && make build`
3. Move `git-secret` file and `man/` folder somewhere inside your `$PATH`, or extend your `$PATH` to contain `git-secret` file and `man/` folder

**`antigen` plugin (or any other `oh-my-zsh`-styled plugin-systems)**

1. Add line `antigen bundle sobolevn/git-secret` to your `.zshrc`
2. Run `source ~/.zshrc` or reopen the terminal

`brew` and `fpm` support is planned.

## Usage
These steps cover the basic process of using `git-secret`:
0. Before starting, make sure you have created `gpg` RSA key-pair: public and secret key identified by your email address.
1. Initialize `git-secret` repository by running `git secret init` command. `.gitsecret/` folder will be created.
2. Add first user to the system by running `git secret tell your@gpg.email-id`.
3. Now it's time to add files you wish to encrypt inside the `git-secret` repository. It can be done by running `git secret add <filenames...>` command. Make sure these files are ignored, otherwise `git secret` won't allow you to add them, as these files will be stored unencrypted.
4. When done, run `git secret hide` all files, which you have added by `git secret add` command will be encrypted with added public-keys by the `git secret tell` command. Now it is safe to commit your cahnges. **But**. It's recommened to add `git secret hide` command to your `pre-commit` hook, so you won't miss any changes.
5. Now decrypt files with `git secret reveal` command. It will ask you for your password. And you're done!

### I want to add someone to the repository
1. Get his `gpg` public-key. **You won't need his secret key.**
2. Import this key inside your `gpg` by running `gpg --import KEY_NAME`
3. Now add this person to the `git-secret` by running `git secret tell persons@email.id`
4. Reencypt the files, now he will be able to decrypt them with his secret key.

Note, that it is possible to add yourself to the system without decrypting existing files. It will possible to decrypt them after reencrypting them with the new key added. So, if you don't want unexpected keys added, make sure to configure some server-side security policy with the `pre-receive` hook.

[1]: https://git-scm.com/
[2]: https://www.gnupg.org/

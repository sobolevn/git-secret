---
layout: post
title: 'git-secret'
date: 2022-06-12 14:02:03 +0000
permalink: git-secret
categories: usage
---
git-secret - bash tool to store private data inside a git repo.
=============================================

## Usage: Setting up git-secret in a repository

These steps cover the basic process of using `git-secret`
to specify users and files that will interact with `git-secret`, 
and to encrypt and decrypt secrets.

0. Before starting, [make sure you have created a `gpg` RSA key-pair](#using-gpg): 
which are a public key and a secret key pair, identified by your email address and
stored with your gpg configuration.
Generally this gpg configuration and keys will be stored somewhere in your home directory.

1. Begin with an existing or new git repository. 

2. Initialize the `git-secret` repository by running `git secret init`. The `.gitsecret/` folder will be created,
with subdirectories `keys/` and `paths/`, 
`.gitsecret/keys/random_seed` will be added to `.gitignore`,
and `.gitignore` will be configured to _not_ ignore `.secret` files.

**Note** all the contents of the `.gitsecret/` folder should be checked in, **/except/** the `random_seed` file.
This also means that of all the files in `.gitsecret/`, only the `random_seed` file should be mentioned in your `.gitignore` file.

3. Add the first user to the `git-secret` repo keyring by running `git secret tell your@email.id`.

4. Now it's time to add files you wish to encrypt inside the `git-secret` repository.
This can be done by running `git secret add <filenames...>` command, which will also (as of 0.2.6) 
add entries to `.gitignore`, stopping those files from being be added or committed to the repo unencrypted. 

5. Then run `git secret hide` to encrypt the files you added with `git secret add`.
The files will be encrypted with the public keys in your git-secret repo's keyring,
each corresponding to a user's email that you used with `tell`.

After using `git secret hide` to encrypt your data, it is safe to commit your changes.
**NOTE:** It's recommended to add the `git secret hide` command to your `pre-commit` hook, so you won't miss any changes.

6. Later you can decrypt files with the `git secret reveal` command, or print their contents to stdout with the
`git secret cat` command. If you used a password on your GPG key (always recommended), it will ask you for your password.
And you're done!

### Usage: Adding someone to a repository using git-secret

1. [Get their `gpg` public-key](#using-gpg). **You won't need their secret key.**
They can export their public key for you using a command like: 
`gpg --armor --export their@email.com > public_key.txt # --armor here makes it ascii`
 
2. Import this key into your `gpg` keyring (in `~/.gnupg` or similar) by running `gpg --import public_key.txt`

3. Now add this person to your secrets repo by running `git secret tell their@email.id`
(this will be the email address associated with their public key)

4. Now remove the other user's public key from your personal keyring with `gpg --delete-keys their@email.id`

5. The newly added user cannot yet read the encrypted files. Now, re-encrypt the files using
`git secret reveal; git secret hide -d`, and then commit and push the newly encrypted files.
(The -d options deletes the unencrypted file after re-encrypting it).
Now the newly added user will be able to decrypt the files in the repo using `git-secret reveal`.

Note that when you first add a user to a git-secret repo, they will not be able to decrypt existing files
until another user re-encrypts the files with the new keyring.  

If you do not
want unexpected keys added, you can configure some server-side security policy with the `pre-receive` hook.

### Using gpg

You can follow a quick `gpg` tutorial at [devdungeon](https://www.devdungeon.com/content/gpg-tutorial). Here are the most useful commands to get started:

To generate a RSA key-pair, run:

```shell
gpg --gen-key
```

To export your public key, run:

```shell
gpg --armor --export your.email@address.com > public-key.gpg
```

To import the public key of someone else (to share the secret with them for instance), run:

```shell
gpg --import public-key.gpg
```

To make sure you get the original public keys of the indicated persons, be sure to use a secure channel to transfer it, or use a service you trust, preferably one that uses encryption such as Keybase, to retrieve their public key. Otherwise you could grant the wrong person access to your secrets by mistake!

### Using git-secret for Continuous Integration / Continuous Deployment (CI/CD)

When using `git-secret` for CI/CD, you get the benefit that any deployment is necessarily done with the correct configuration, since it is collocated
with the changes in your code.

One way of doing it is the following:

1. [create a gpg key](#using-gpg) for your CI/CD environment. You can chose any name and email address you want: for instance `MyApp Example <myapp@example.com>`
if your app is called MyApp and your CI/CD provider is Example. It is easier not to define a passphrase for that key. However, if defining a passphrase is unavoidable, use a unique passphrase for the private key.
2. run `gpg --armor --export-secret-key myapp@example.com` to get your private key value
3. Create an env var on your CI/CD server `GPG_PRIVATE_KEY` and assign it the private key value. If a passphrase has been setup for the private key, create another env var on the CI/CD server `GPG_PASSPHRASE` and assign it the passphrase of the private key.
4. Then write your Continuous Deployment build script. For instance:

```shell
# As the first step: install git-secret,
# see: https://git-secret.io/installation

# Create private key file
echo "$GPG_PRIVATE_KEY" > ./private_key.gpg
# Import private key and avoid the "Inappropriate ioctl for device" error
gpg --batch --yes --pinentry-mode loopback --import private_key.gpg
# Reveal secrets without user interaction and with passphrase. If no passphrase
# is created for the key, remove `-p $GPG_PASSPHRASE`
git secret reveal -p "$GPG_PASSPHRASE"
# carry on with your build script, secret files are available ...
```

Note: your CI/CD might not allow you to create a multiline value. In that case, you can export it on one line with

```shell
gpg --armor --export-secret-key myapp@example.com | tr '\n' ','
```

You can then create your private key file with:

```shell
echo "$GPG_PRIVATE_KEY" | tr ',' '\n' > ./private_key.gpg
```

Also note: the `gpg` version on the CI/CD server **MUST INTEROPERATE** with the one used locally. Otherwise, `gpg` decryption can fail, which leads to `git secret reveal` reporting `cannot find decrypted version of file` error. The best way to ensure this is to use the same version of gnupg on different systems.

## Environment Variables and Configuration

You can configure the version of `gpg` used, or the extension your encrypted files use, to suit your workflow better.
To do so, just set the required variable to the value you need.
This can be done in your shell environment file or with each `git-secret` command.
See below, or the man page of `git-secret` for an explanation of the environment variables `git-secret` uses.

The settings available to be changed are:

* `$SECRETS_VERBOSE` - sets the verbose flag to on for all `git-secret` commands; is identical to using `-v` on each command that supports it.

* `$SECRETS_GPG_COMMAND` - sets the `gpg` alternatives, defaults to `gpg`.
It can be changed to `gpg`, `gpg2`, `pgp`, `/usr/local/gpg` or any other value.
After doing so rerun the tests to be sure that it won't break anything. Tested with `gpg` and `gpg2`.

* `$SECRETS_GPG_ARMOR` - sets the `gpg` [`--armor` mode](https://www.gnupg.org/gph/en/manual/r1290.html). Can be set to `1` to store secrets file as text. By default is `0` and store files as binaries.

* `$SECRETS_EXTENSION` - sets the secret files extension, defaults to `.secret`. It can be changed to any valid file extension.

* `$SECRETS_DIR` - sets the directory where `git-secret` stores its files, defaults to `.gitsecret`. It can be changed to any valid directory name.

* `$SECRETS_PINENTRY` - allows user to specify a setting for `gpg`'s `--pinentry` option. See [`gpg` docs](https://github.com/gpg/pinentry) for details about gpg's `--pinentry` option.

## The `.gitsecret` folder (can be overridden with `SECRETS_DIR`)

This folder contains information about the files encrypted by git-secret,
and about which public/private key sets can access the encrypted data.

You can change the name of this directory using the SECRETS_DIR environment variable.

Use the various `git-secret` commands to manipulate the files in `.gitsecret`,
you should not change the data in these files directly.

Exactly which files exist in the `.gitsecret` folder and what their contents are
vary slightly across different versions of gpg. Also, some versions of gpg
might not work well with keyrings created or modified with newer versions of gpg. 
Thus it is best to use git-secret with the same version of gpg being used by all users.
This can be forced by installing matching versions of gpg 
and using `SECRETS_GPG_COMMAND` environment variable.

For example, there is an issue between `gpg` version 2.1.20 and later versions
which can cause problems reading and writing keyring files between systems
(this shows up in errors like 'gpg: skipped packet of type 12 in keybox').

This is not the only issue it is possible to encounter sharing files between different versions
of `gpg`.
Generally you are most likely to encounter issues between `gpg`
versions if you use `git-secret tell` or `git-secret removeperson` to modify
your repo's `git-secret` keyring using a newer version of `gpg`, and then try to operate
on that keyring using an older version of `gpg`.

The `git-secret` internal data is separated into two directories:

### `.gitsecret/paths`

This directory currently contains only the file `mapping.cfg`, which lists all the files your storing encrypted.
In other words, the path mappings: what files are tracked to be hidden and revealed.

All the other internal data is stored in the directory:

### `.gitsecret/keys`

This directory contains data used by `git-secret` and `gpg` to encrypt files to 
be accessed by the permitted users.

In particular, this directory contains a `gnupg keyring` with public keys for the emails used with `tell`.

This is the keyring used to encrypt files with `git-secret-hide`. 

`git-secret-reveal` and `git-secret-cat`, which decrypt secrets,
instead use the user's _private keys_ (which probably reside somewhere like ~/.gnupg/).
Note that user's private keys, needed for decryption, are _not_ in the `.gitsecret/keys` directory.

Generally speaking, all the files in this directory *except* `random_seed` should be checked into your repo.
By default, `git secret init` will add the file `.gitsecret/keys/random_seed` to your `.gitignore` file.

Again, you can change the name of this directory using the SECRETS_DIR environment variable.

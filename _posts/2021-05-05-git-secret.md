---
layout: post
title:  'git-secret'
date:   2021-05-05 17:13:15 +0000
permalink: git-secret
categories: usage
---
git-secret - bash tool to store private data inside a git repo.
=============================================

## Usage: Setting up git-secret in a repository

These steps cover the basic process of using `git-secret`:

0. Before starting, [make sure you have created a `gpg` RSA key-pair](#using-gpg): a public and a secret key identified by your email address.

1. Begin with an existing or new git repository. You'll use the 'git secret' commands to add the keyrings and information
to make `git-secret` hide and reveal files in this repository.

2. Initialize the `git-secret` repository by running `git secret init` command. The `.gitsecret/` folder will be created.
**Note** all the contents of the `.gitsecret/` folder should be checked in, **/except/** the `random_seed` file.
In other words, of all the files in `.gitsecret/`, only the `random_seed` file should be mentioned in your `.gitignore` file.
By default, `git secret init` will add the file `.gitsecret/keys/random_seed` to your `.gitignore` file.

3. Add the first user to the `git-secret` repo keyring by running `git secret tell your@gpg.email`.

4. Now it's time to add files you wish to encrypt inside the `git-secret` repository.
This can be done by running `git secret add <filenames...>` command. Make sure these files are ignored by mentions in
`.gitignore`, otherwise `git-secret` won't allow you to add them, as these files could be stored unencrypted. In the default configuration, `git-secret add` will automatically add the unencrypted versions of the files to `.gitignore` for you.

5. When done, run `git secret hide` to encrypt all files which you have added by the `git secret add` command.
The data will be encrypted with the public-keys described by the `git secret tell` command.
After using `git secret hide` to encrypt your data, it is safe to commit your changes.
**NOTE:** It's recommended to add the `git secret hide` command to your `pre-commit` hook, so you won't miss any changes.

6. Later you can decrypt files with the `git secret reveal` command, or just print their contents to stdout with the
`git secret cat` command. If you used a password on your GPG key (always recommended), it will ask you for your password.
And you're done!

### Usage: Adding someone to a repository using git-secret

1. [Get their `gpg` public-key](#using-gpg). **You won't need their secret key.**

2. Import this key into your `gpg` keyring (in `~/.gnupg` or similar) by running `gpg --import KEY_NAME.txt`

3. Now add this person to your secrets repo by running `git secret tell persons@email.id`
(this will be the email address associated with the public key)

4. The newly added user cannot yet read the encrypted files. Now, re-encrypt the files using
`git secret reveal; git secret hide -d`, and then commit and push the newly encrypted files.
(The -d options deletes the unencrypted file after re-encrypting it).
Now the newly added user will be able to decrypt the files in the repo using `git-secret reveal`.

Note that it is possible to add yourself to the git-secret repo without decrypting existing files.
It will be possible to decrypt them after re-encrypting them with the new keyring. So, if you don't
want unexpected keys added, you can configure some server-side security policy with the `pre-receive` hook.

### Using gpg

You can follow a quick `gpg` tutorial at [devdungeon](https://www.devdungeon.com/content/gpg-tutorial). Here are the most useful commands to get started:

To generate a RSA key-pair, run:

```shell
gpg --gen-key
```

To export your public key, run:

```shell
gpg --export your.email@address.com --armor > public-key.gpg
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

1. [create a gpg key](#using-gpg) for your CI/CD environment. You can chose any name and email address you want: for instance `MyApp CodeShip <myapp@codeship.com>`
if your app is called MyApp and your CI/CD provider is CodeShip. It is easier not to define a password for that key.
2. run `gpg --export-secret-key myapp@codeship.com --armor` to get your private key value
3. Create an env var on your CI/CD server `GPG_PRIVATE_KEY` and assign it the private key value.
4. Then write your Continuous Deployment build script. For instance:

```shell
# Install git-secret (https://git-secret.io/installation), for instance, for debian:
echo "deb https://dl.bintray.com/sobolevn/deb git-secret main" | sudo tee -a /etc/apt/sources.list
wget -qO - https://api.bintray.com/users/sobolevn/keys/gpg/public.key | sudo apt-key add -
sudo apt-get update && sudo apt-get install git-secret
# Create private key file
echo $GPG_PRIVATE_KEY > ./private_key.gpg
# Import private key
gpg --import ./private_key.gpg
# Reveal secrets
git secret reveal
# carry on with your build script, secret files are available ...
```

Note: your CI/CD might not allow you to create a multiline value. In that case, you can export it on one line with

```shell
gpg --export-secret-key myapp@codeship.com --armor | tr '\n' ','
```

You can then create your private key file with:

```shell
echo $GPG_PRIVATE_KEY | tr ',' '\n' > ./private_key.gpg
```

## Environment Variables and Configuration

You can configure the version of `gpg` used, or the extension your encrypted files use, to suit your workflow better.
To do so, just set the required variable to the value you need.
This can be done in your shell environment file or with each `git-secret` command.
See below, or the man page of `git-secret` for an explanation of the environment variables `git-secret` uses.

The settings available to be changed are:

* `$SECRETS_VERBOSE` - sets the verbose flag to on for all `git-secret` commands; is identical
to using `-v` on each command that supports it.

* `$SECRETS_GPG_COMMAND` - sets the `gpg` alternatives, defaults to `gpg`.
It can be changed to `gpg`, `gpg2`, `pgp`, `/usr/local/gpg` or any other value.
After doing so rerun the tests to be sure that it won't break anything. Tested to be working with: `gpg`, `gpg2`.

* `$SECRETS_EXTENSION` - sets the secret files extension, defaults to `.secret`. It can be changed to any valid file extension.

* `$SECRETS_DIR` - sets the directory where git-secret stores its files, defaults to .gitsecret.
It can be changed to any valid directory name.

* `$SECRETS_PINENTRY` - allows user to specify a setting for `gpg`'s --pinentry option.
See `gpg` docs for details about gpg's --pinentry option.

## The `.gitsecret` folder (can be overridden with SECRETS_DIR)

This folder contains information about the files encrypted by git-secret,
and about which public/private key sets can access the encrypted data.

You can change the name of this directory using the SECRETS_DIR environment variable.

Use the various 'git secret' commands to manipulate the files in `.gitsecret`,
you should not change the data in these files directly.

Exactly which files exist in the `.gitsecret` folder and what their contents are
vary slightly across different versions of gpg. Thus it is best to use
git-secret with the same version of gpg being used by all users.
This can be forced using SECRETS_GPG_COMMAND environment variable.

Specifically, there is an issue between gpg version 2.1.20 and later versions
which can cause problems reading and writing keyring files between systems
(this shows up in errors like 'gpg: skipped packet of type 12 in keybox').

The git-secret internal data is separated into two directories:

### `.gitsecret/paths`

This directory currently contains only the file `mapping.cfg`, which lists all the files your storing encrypted.
In other words, the path mappings: what files are tracked to be hidden and revealed.

All the other internal data is stored in the directory:

### `.gitsecret/keys`

This directory contains data used by git-secret and PGP to allow and maintain the correct encryption and access rights for the permitted parties.

Generally speaking, all the files in this directory *except* `random_seed` should be checked into your repo.
By default, `git secret init` will add the file `.gitsecret/keys/random_seed` to your `.gitignore` file.

Again, you can change the name of this directory using the SECRETS_DIR environment variable.

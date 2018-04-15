---
layout: default
---

# Tutorial

## Pre-requisites

We assume that you already have `git-secret` and gpg (or gnupg or gpg2 or similar)
installed as explained in the installation docs.

## Quick Reference: for the experienced

### If you do not already have a gpg public/private key pair.

    gpg --key-gen
        (answer questions as appropriate)

### Adding git-secret to a git repository

    git checkout git@github.com:username/project.git
    cd project.git
    git secret init
        [MORE HERE- ADD ACCESS FOR THIS USER]
    echo 'config.ini' >> .gitignore
    echo 'Secret-here: THIS_IS_A_SECRET' > config.ini
    git secret add config.ini
    git secret hide
    git add config.ini.secret
    git commit -m 'this is the encrypted secret' config.ini.secret
    rm -f config.ini

## Detailed steps to add secrets to a repository

### Checkout a git repository which you want to add secrets to

You can create a new repo to hold encrypted secrets, or you can add secrets to an existing repo. 
Either way, checkout the repo you want to add the secrets too and cd into the checkout directory.

### Make sure you have your gpg / gnupg public-private key pair set up.

If you don't already have a gpg public/private key pair, use
    
    gpg -key-gen
 
or a similar command to create your GPG public and private keys.  Note that you must protect the
private key, in particular, from being read by anyone but yourself and the processes you run.

### Run `git secret init`

While in the directory with the checked-out project you want to add secrets to, run the command
    
    git secret init

This will create the .gitsecret directory and add the entry .gitsecret/keys/random_seed to 
your .gitignore file.

### Set up the file(s) for the secret(s)

Create the files you want to store the secrets in (probably small files like `config.yml`
or `app.ini`).

You might as well also put some real (or sample) secrets into those files.

Then add the filenames of the files with secrets to .gitignore.  Note that git-secret will only encrypt files 
that are specifically listed in .gitignore

### Encrypt your secret files

Now just run

        git secret hide

to encrypt your files and rename them like `config.yml.secret`.

### Add your encypted files to your repo and commit them.

Now you can safely commit your encrypted files into your repo.  For example:

    git add config.yml.secret
    git commit -m 'encrypted copy of config.yml' config.yml.secret
    git push

### Later you can use `git secret cat` or `git secret reveal` to decrypt your secrets

Now only people specifically permissioned (via their gpg public keys) to decrypt the data
can do so. You can use the various `git secret` commands to add or revoke permissions 
or re-encrypt your data. Remember to also generate new keys and re-encrypt them after you 
revoke permissions for users.

### DESCRIBE IMPORTANT SUBSET OF git secret COMMANDS HERE

    usage: git secret [add|cat|changes|clean|hide|init|killperson|list|remove|reveal|tell|usage|whoknows]



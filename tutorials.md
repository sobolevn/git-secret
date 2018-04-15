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
or `app.ini`) and add them to .gitignore.

git-secret will only encrypt files that are specifically listed in .gitignore






---
layout: post
title: 'git-secret-reveal'
date: 2022-06-05 09:31:37 +0000
permalink: git-secret-reveal
categories: command
---
git-secret-reveal - decrypts all added files.
=============================================

## SYNOPSIS

    git secret reveal [-f] [-F] [-P] [-v] [-d dir] [-p password] [pathspec]...


## DESCRIPTION
`git-secret-reveal` - decrypts passed files, or all files considered secret by `git-secret`.

Under the hood, `reveal` uses the `gpg --decrypt` command
and your private key (typically from your personal keyring in your
home directory) to _decrypt_ files.

Therefore, for this operation to succeed, your personal keyring must contain a private key 
matching one of the public keys which were used to encrypt the secrets --
i.e., one of the public keys in your repo's `git-secret` keyring when the file was encrypted. 



## OPTIONS

    -f  - forces gpg to overwrite existing files without prompt.
    -F  - forces reveal to continue even if a file fails to decrypt.
    -d  - specifies `--homedir` option for the `gpg`, basically use this option if you store your keys in a custom location.
    -v  - verbose, shows extra information.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -P  - preserve permissions of encrypted file in unencrypted file.
    -h  - shows help.


## ENV VARIABLES

- `SECRETS_GPG_COMMAND` changes the default `gpg` command to anything else
- `SECRETS_GPG_ARMOR` is a boolean to enable [`--armor` mode](https://www.gnupg.org/gph/en/manual/r1290.html) to store secrets in text format over binary
- `SECRETS_DIR` changes the default `.gitsecret/` folder to another name as documented at [git-secret(7)](https://git-secret.io/)
- `SECRETS_EXTENSION` changes the default `.secret` file extension
- `SECRETS_VERBOSE` changes the output verbosity as documented at [git-secret(7)](https://git-secret.io/)
- `SECRETS_PINENTRY` changes the [`gpg --pinentry` mode](https://github.com/gpg/pinentry) as documented at [git-secret(7)](https://git-secret.io/)


## MANUAL

Run `man git-secret-reveal` to see this document.


## SEE ALSO

[git-secret-init(1)](https://git-secret.io/git-secret-init), [git-secret-cat(1)](https://git-secret.io/git-secret-cat),
[git-secret-tell(1)](https://git-secret.io/git-secret-tell), [git-secret-add(1)](https://git-secret.io/git-secret-add),
[git-secret-hide(1)](https://git-secret.io/git-secret-hide)

git-secret-hide - encrypts all added files with the inner keyring.
==================================================================

## SYNOPSIS

    git secret hide [-c] [-F] [-P] [-v] [-d] [-m]


## DESCRIPTION
`git-secret-hide` creates an encrypted version (typically called `filename.txt.secret`)
of each file added by `git-secret-add` command.
Now anyone enabled via `git secret tell` can can decrypt these files. Under the hood,
`git-secret` uses the keyring in `.gitsecret/keys` and user's secret keys to decrypt the files.

It is recommended to encrypt (or re-encrypt) all the files in a `git-secret` repo each
time `git secret hide` is run.

Otherwise the keychain (the one stored in `.gitsecret/keys/*.gpg`),
may have changed since the last time the files were encrypted, and it's possible
to create a state where the users in the output of `git secret whoknows`
may not be able to decrypt the some files in the repo, or may be able decrypt files
they're not supposed to be able to.

In other words, unless you re-encrypt all the files in a repo each time you `hide` any,
it's possible to make it so some files can no longer be decrypted by users who should be
(and would appear) able to decrypt them, and vice-versa.

If you know what you are doing and wish
to encrypt or re-encrypt only a subset of the files
even after reading the above paragraphs, you can use the `-F` or `-m` options.
The `-F` option forces `git secret hide` to skip any hidden files
where the unencrypted versions aren't present.
The `-m` option skips any hidden files that have
not be been modified since the last time they were encrypted.


## OPTIONS

    -v  - verbose, shows extra information.
    -c  - deletes encrypted files before creating new ones.
    -F  - forces hide to continue if a file to encrypt is missing.
    -P  - preserve permissions of unencrypted file in encrypted file.
    -d  - deletes unencrypted files after encryption.
    -m  - encrypt files only when modified.
    -h  - shows help.


## ENV VARIABLES

- `SECRETS_GPG_COMMAND` changes the default `gpg` command to anything else
- `SECRETS_GPG_ARMOR` is a boolean to enable [`--armor` mode](https://www.gnupg.org/gph/en/manual/r1290.html) to store secrets in text format over binary
- `SECRETS_DIR` changes the default `.gitsecret/` folder to another name as documented at [git-secret(7)](https://git-secret.io/)
- `SECRETS_EXTENSION` changes the default `.secret` file extension
- `SECRETS_VERBOSE` changes the output verbosity as documented at [git-secret(7)](https://git-secret.io/)
- `SECRETS_PINENTRY` changes the [`gpg --pinentry` mode](https://github.com/gpg/pinentry) as documented at [git-secret(7)](https://git-secret.io/)


## MANUAL

Run `man git-secret-hide` to see this note.


## SEE ALSO

[git-secret-init(1)](https://git-secret.io/git-secret-init), [git-secret-tell(1)](https://git-secret.io/git-secret-tell),
[git-secret-add(1)](https://git-secret.io/git-secret-add), [git-secret-reveal(1)](https://git-secret.io/git-secret-reveal),
[git-secret-cat(1)](https://git-secret.io/git-secret-cat)

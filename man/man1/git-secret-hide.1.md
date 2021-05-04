git-secret-hide - encrypts all added files with the inner keyring.
==================================================================

## SYNOPSIS

    git secret hide [-c] [-F] [-P] [-v] [-d] [-m]


## DESCRIPTION
`git-secret-hide` creates an encrypted version (typically called `filename.txt.secret`) 
of each file added by `git-secret-add` command. 
Now anyone enabled via 'git secret tell' can can decrypt these files. Under the hood,
`git-secret` uses the keyring in `.gitsecret/keys` and user's secret keys to decrypt the files.

It is recommended to encrypt (or re-encrypt) all the files in a git-secret repo each 
time `git secret hide` is run.

Otherwise the keychain (the one stored in `.gitsecret/keys/*.gpg`),
may have changed since the last time the files were encrypted, and it's possible 
to create a state where the users in the output of `git secret whoknows` 
may not be able to decrypt the some files in the repo, or may be able decrypt files 
they're not supposed to be able to.

In other words, unless you re-encrypt all the files in a repo each time you 'hide' any, 
it's possible to make it so some files can no longer be decrypted by users who should be 
(and would appear) able to decrypt them, and vice-versa.

If you know what you are doing and wish to encrypt or re-encrypt only a subset of the files 
even after reading the above paragraphs, you can use the -F or -m option to only encrypted 
a subset of files. The -F option forces `git secret hide` to skip any hidden files 
where the unencrypted versions aren't present. The -m option skips any hidden files that have 
not be modified since the last time they were encrypted. 

Also, it is possible to modify the names of the encrypted files by setting `SECRETS_EXTENSION` variable.

(See [git-secret(7)](http://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the SECRETS_DIR environment variable.

You can also enable verbosity using the SECRETS_VERBOSE environment variable,
as documented at [git-secret(7)](http://git-secret.io/)


## OPTIONS

    -v  - verbose, shows extra information.
    -c  - deletes encrypted files before creating new ones.
    -F  - forces hide to continue if a file to encrypt is missing.
    -P  - preserve permissions of unencrypted file in encrypted file.
    -d  - deletes unencrypted files after encryption.
    -m  - encrypt files only when modified.
    -h  - shows help.

## MANUAL

Run `man git-secret-hide` to see this note.


## SEE ALSO

[git-secret-init(1)](http://git-secret.io/git-secret-init), [git-secret-tell(1)](http://git-secret.io/git-secret-tell), 
[git-secret-add(1)](http://git-secret.io/git-secret-add), [git-secret-reveal(1)](http://git-secret.io/git-secret-reveal),  
[git-secret-cat(1)](http://git-secret.io/git-secret-cat)

git-secret-reveal - decrypts all added files.
=============================================

## SYNOPSIS

    git secret reveal [-f] [-F] [-P] [-v] [-d dir] [-p password] [pathspec]...


## DESCRIPTION
`git-secret-reveal` - decrypts all the files in `.gitsecret/paths/mapping.cfg`,
or the passed `pathspec`s.
You will need to have imported the paired secret-key with one of the 
public-keys which were used in the encryption.
Under the hood, this uses the `gpg --decrypt` command. 


## OPTIONS

    -f  - forces gpg to overwrite existing files without prompt.
    -F  - forces reveal to continue even if a file fails to decrypt.
    -d  - specifies `--homedir` option for the `gpg`, basically use this option if you store your keys in a custom location.
    -v  - verbose, shows extra information.
    -p  - specifies password for noinput mode, adds `--passphrase` option for `gpg`.
    -P  - preserve permissions of encrypted file in unencrypted file.
    -h  - shows help.

(See [git-secret(7)](http://git-secret.io/git-secret) for information about renaming the .gitsecret
folder using the SECRETS_DIR environment variable.


## MANUAL

Run `man git-secret-reveal` to see this note.


## SEE ALSO

[git-secret-init(1)](http://git-secret.io/git-secret-init), [git-secret-cat(1)](http://git-secret.io/git-secret-cat), 
[git-secret-tell(1)](http://git-secret.io/git-secret-tell), [git-secret-add(1)](http://git-secret.io/git-secret-add), 
[git-secret-hide(1)](http://git-secret.io/git-secret-hide)

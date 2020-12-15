git-secret-init - initializes git-secret repository.
====================================================

## SYNOPSIS

    git secret init


## DESCRIPTION
`git-secret-init` should be run inside a `git` repo to set up the .gitsecret directory and initialize the repo for git-secret.
Until repository is initialized with `git secret init`, all other `git-secret` commands are unavailable.

If a .gitsecret directory already exists, `git-secret-init` exits without making any changes.
Otherwise, a .gitsecret directory is created with appropriate sub-directories,
and patterns to ignore git-secret's `random_seed_file`
and not ignore `.secret` files are added to `.gitignore`.  

(See [git-secret(7)](http://git-secret.io/git-secret) for information about renaming the .gitsecret
folder with the SECRETS_DIR environment variable, and changing the extension git-secret uses for secret files
with the SECRETS_EXTENSION environment variable.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-init` to see this note.


## SEE ALSO

[git-secret-usage(1)](http://git-secret.io/git-secret-usage), [git-secret-tell(1)](http://git-secret.io/git-secret-tell)

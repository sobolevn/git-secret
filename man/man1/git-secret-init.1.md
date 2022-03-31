git-secret-init - initializes git-secret repository.
====================================================

## SYNOPSIS

    git secret init


## DESCRIPTION
`git-secret-init` should be run inside a `git` repo to set up the .gitsecret directory and initialize the repo for git-secret.
Until repository is initialized with `git secret init`, all other `git-secret` commands are unavailable.

If a `.gitsecret` directory already exists, `git-secret-init` exits without making any changes.
Otherwise, 

* `.gitignore` is modified to ignore `git-secret`'s `random_seed_file`,
and to not ignore `.secret` files,

* a .gitsecret directory is created with the sub-directories /keys and /paths,

* The `.gitsecret/keys` subdirectory permissions are set to 700 to make gnupg happy.

(See [git-secret(7)](https://git-secret.io/git-secret) for information about renaming the .gitsecret
folder with the `SECRETS_DIR` environment variable, and changing the extension `git-secret` uses for secret files
with the `SECRETS_EXTENSION` environment variable.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-init` to see this note.


## SEE ALSO

[git-secret-usage(1)](https://git-secret.io/git-secret-usage), [git-secret-tell(1)](https://git-secret.io/git-secret-tell)

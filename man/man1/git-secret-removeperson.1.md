git-secret-removeperson - deletes key identified by an email from the inner keyring.
==================================================================================

## SYNOPSIS

    git secret removeperson <emails>...


## DESCRIPTION
`git-secret-removeperson` - removes the keys associated with the passed email addresses 
from the repo's `git-secret` keyring.

If you remove a user's access with `git-secret-removeperson`, and run `git-secret-reveal` and `git-secret-hide -r`,
it will no longer be possible for that user to decrypt the hidden files.


## OPTIONS

    -h  - shows this help.


## MANUAL

Run `man git-secret-removeperson` to see this note.


## SEE ALSO

[git-secret-tell(1)](https://git-secret.io/git-secret-tell), [git-secret-remove(1)](https://git-secret.io/git-secret-remove),
[git-secret-clean(1)](https://git-secret.io/git-secret-clean)

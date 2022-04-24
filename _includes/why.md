
## Intro

There's a well-known problem in deploying and configuring software on servers, 
where you generally have to store your private data 
(such as database passwords, application secret-keys, OAuth secret keys, etc) 
outside of the git repository. 

If you do choose to store these secrets unencrypted in your git repo, 
even if the repository is private, it is a security risk to just copy 
these secrets everywhere you check out your repo.

What are some drawbacks of storing secrets separately from your git repo?

1. These files are not version controlled. 
Filenames, locations, and passwords change from time to time; 
or some new information appears, and other information is removed. 
When secrets are stored separately from your repo,
you can not tell for sure which version of the configuration file was used with each commit
or deploy.

2. When building the automated deployment system there will be one extra step: 
download and place these secret-configuration files where they need to be. 
So you have to maintain _extra_ secure servers, where all your secrets are stored.


### How does `git-secret` solve these problems?

1. `git-secret` encrypts files and stores them inside the `git` repository, so you will have all the changes for every commit.
2. `git-secret` doesn't require any other deploy operations other than providing the appropriate
private key (to allow decryption), and using `git secret reveal`, 
to automatically decrypt all the secret files.

### What is `git-secret`?

`git-secret` is a bash tool to store your private data inside a `git` repo. 
How's that? Basically, it encrypts, using `gpg`, the tracked files with the 
public keys of all the users that you trust (and which you have specified with
`git secret tell email@address.id`. 
Then permitted users can decrypt these files using only their personal secret key. 
Why deal with all this private-public keys stuff? 
To make it easier to manage access rights. 
When you want to remove someone's access, use `git secret removeperson email@address.id`
to delete their public key from your repo's git-secret keyring, and reencrypt the files. 
Then they won't be able to decrypt secrets anymore.

[![git-secret terminal preview](https://raw.githubusercontent.com/sobolevn/git-secret/master/git-secret.gif)](https://asciinema.org/a/41811?autoplay=1)

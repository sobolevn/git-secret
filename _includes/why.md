
## Intro

There's a known problem in server configuration and deploying, when you have to store your private data such as: database passwords, application secret-keys, OAuth secret keys and so on, outside of the git repository. Even if this repository is private, it is a security risk to just publish them into the world wide web. What are the drawbacks of storing them separately?

1. These files are not version controlled. Filenames change, locations change, passwords change from time to time, some new information appears, other is removed. And you can not tell for sure which version of the configuration file was used with each commit.
2. When building the automated deployment system there will be one extra step: download and place these secret-configuration files where they need to be. So you have to maintain an extra secure server, where everything is stored.

### How does `git-secret` solve these problems?

1. `git-secret` encrypts files and stores them inside the `git` repository, so you will have all the changes for every commit.
2. `git-secret` doesn't require any other deploy operations rather than `git secret reveal`, so it will automatically decrypt all the required files.

### What is `git-secret`?

`git-secret` is a bash tool to store your private data inside a `git` repo. How's that? Basically, it just encrypts, using `gpg`, the tracked files with the public keys of all the users that you trust. So everyone of them can decrypt these files using only their personal secret key. Why deal with all this private-public keys stuff? Well, to make it easier for everyone to manage access rights. There are no passwords that change. When someone is out - just delete their public key, reencrypt the files, and they won't be able to decrypt secrets anymore.

[![git-secret terminal preview](git-secret.gif)](https://asciinema.org/a/41811?autoplay=1)

# git-secret

[![Build Status](https://secure.travis-ci.org/sobolevn/git-secret.png?branch=master)](https://travis-ci.org/sobolevn/git-secret) [![Dockerhub](https://img.shields.io/docker/pulls/sobolevn/git-secret.svg)](https://hub.docker.com/r/sobolevn/git-secret/)

[![git-secret](https://raw.githubusercontent.com/sobolevn/git-secret/gh-pages/images/git-secret-big.png)](https://sobolevn.github.io/git-secret/)

## What is `git-secret`?

`git-secret` is a bash tool to store your private data inside a git repo. How’s that? Basically, it just encrypts, using `gpg`, the tracked files with the public keys of all the users that you trust. So everyone of them can decrypt these files using only their personal secret key. Why deal with all this private-public keys stuff? Well, to make it easier for everyone to manage access rights. There are no passwords that change. When someone is out - just delete his public key, re-encrypt the files, and he won’t be able to decrypt secrets anymore.

## Preview

[![git-secret terminal preview](https://asciinema.org/a/41811.png)](https://asciinema.org/a/41811?autoplay=1)

## Usage

See the [git-secret site](https://sobolevn.github.io/git-secret/).

## Installation

See the [installation section](https://sobolevn.github.io/git-secret/#installation).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## License

MIT. See [LICENSE.md](LICENSE.md) for details.

## Thanks

Special thanks to [@elioqoshi](https://github.com/elioqoshi) for awesome logo.

# git-secret


[![test](https://github.com/sobolevn/git-secret/actions/workflows/test.yml/badge.svg?branch=master&event=push)](https://github.com/sobolevn/git-secret/actions/workflows/test.yml)
[![release-ci](https://github.com/sobolevn/git-secret/actions/workflows/release-ci.yml/badge.svg)](https://github.com/sobolevn/git-secret/actions/workflows/release-ci.yml)
[![Homebrew](https://img.shields.io/homebrew/v/git-secret.svg)](https://formulae.brew.sh/formula/git-secret)
[![Supporters](https://img.shields.io/opencollective/all/git-secret.svg?color=gold&label=supporters)](https://opencollective.com/git-secret)

[![git-secret](https://raw.githubusercontent.com/sobolevn/git-secret/gh-pages/images/git-secret-big.png)](https://git-secret.io/)


## What is `git-secret`?

`git-secret` is a bash tool which stores private data inside a git repo.
`git-secret` encrypts files with permitted users' public keys,
allowing users you trust to access encrypted data using pgp and their secret keys.

With `git-secret`, changes to access rights are simplified, and private-public key issues are handled for you.

When someone's permission is revoked, secrets do not need to be changed with `git-secret` -
just remove their key from the repo's keyring using `git secret removeperson their@email.com`,
re-encrypt the files, and they won't be able to decrypt secrets anymore.
If you think the user might have copied the secrets or keys when they had access, then
you should also change the secrets.


## Preview

[![git-secret terminal preview](git-secret.gif)](https://asciinema.org/a/41811?autoplay=1)


## Installation

`git-secret` [supports `brew`](https://formulae.brew.sh/formula/git-secret), just type: `brew install git-secret`

It also supports `apt` and `yum`. You can also use `make` if you want to.
See the [installation section](https://sobolevn.me/git-secret/installation) for the details.

### Requirements

`git-secret` relies on several external packages:

- `bash` since `3.2.57` (it is hard to tell the correct `patch` release)
- `gawk` since `4.0.2`
- `git` since `1.8.3.1`
- `gpg` since `gnupg 1.4` to `gnupg 2.X`
- `sha256sum` since `8.21` (on freebsd and MacOS `shasum` is used instead)


## Contributing

Do you want to help the project? Find an [issue](https://github.com/sobolevn/git-secret/issues)
and send a PR. It is more than welcomed! See [CONTRIBUTING.md](CONTRIBUTING.md) on how to do that.

### Security

In order to encrypt (git-secret hide -m) files only when modified, the path
mappings file tracks sha256sum checksums of the files added (git-secret add) to
git-secret's path mappings filesystem database. Although, the chances of
encountering a sha collision are low, it is recommend that you pad files with
random data for greater security. Or avoid using  the `-m` option altogether.
If your secret file holds more data than just a single password these
precautions should not be necessary, but could be followed for greater
security.

If you found any security related issues, please do not disclose it in public. Send an email to `security@wemake.services`


## Changelog

`git-secret` uses [semver](https://semver.org/). See [CHANGELOG.md](CHANGELOG.md).


## Packagers

Thanks to all the people and groups who package `git-secret` for easier install on particular OSes and distributions!

[![Packaging status](https://repology.org/badge/vertical-allrepos/git-secret.svg)](https://repology.org/project/git-secret/versions)

Here are some packagings of `git-secret` that we're aware of:

- https://formulae.brew.sh/formula/git-secret
- https://packages.ubuntu.com/bionic/git-secret
- https://src.fedoraproject.org/rpms/git-secret
- https://aur.archlinux.org/packages/git-secret/
- https://pkgs.alpinelinux.org/package/edge/testing/x86/git-secret
- https://packages.debian.org/sid/git-secret
- https://github.com/void-linux/void-packages/blob/master/srcpkgs/git-secret/template

Such packages are considered 'downstream' because the git-secret code 'flows' from the `git-secret` [repository](https://git-secret.io/installation)
to the various rpm/deb/dpkg/etc packages that are created for specific OSes and distributions.

We have also added notes specifically for packagers in [CONTRIBUTING.md](CONTRIBUTING.md).


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/git-secret#sponsor)]

[![Sponsors](https://opencollective.com/git-secret/tiers/sponsor.svg?width=890)](https://opencollective.com/git-secret)


## Backers

Thanks to all our backers!

[![Backers](https://opencollective.com/git-secret/tiers/backer.svg?width=890&avatarHeight=36)](https://opencollective.com/git-secret)


## Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/sobolevn/git-secret/graphs/contributors"><img src="https://opencollective.com/git-secret/contributors.svg?width=890" /></a>


## License

MIT. See [LICENSE.md](LICENSE.md) for details.


## Thanks

Special thanks to [Elio Qoshi](https://elioqoshi.me/sq/) from [ura](http://ura.design/) for the awesome logo.

# git-secret

[![Backers on Open Collective](https://opencollective.com/git-secret/backers/badge.svg)](#backers) [![Sponsors on Open Collective](https://opencollective.com/git-secret/sponsors/badge.svg)](#sponsors) [![Build Status](https://img.shields.io/travis/sobolevn/git-secret/master.svg)](https://travis-ci.org/sobolevn/git-secret) [![Homebrew](https://img.shields.io/homebrew/v/git-secret.svg)](https://formulae.brew.sh/formula/git-secret) [![Bintray deb](https://img.shields.io/bintray/v/sobolevn/deb/git-secret.svg)](https://bintray.com/sobolevn/deb/git-secret/view)

[![git-secret](https://raw.githubusercontent.com/sobolevn/git-secret/gh-pages/images/git-secret-big.png)](http://git-secret.io/)


## What is `git-secret`?

`git-secret` is a bash tool which stores private data inside a git repo. 
`git-secret` encrypts files with permitted users' public keys,
allowing users you trust to access encrypted data using pgp and their secret keys. 

With `git-secret`, changes to access rights are simplified, and private-public key issues are handled for you. 

When someone's permission is revoked, secrets do not need to be changed with `git-secret` -
just remove their key from the keychain using `git secret killperson their@email.com`, 
re-encrypt the files, and they won't be able to decrypt secrets anymore.
If you think the user might have copied the contents of the keys when they had access, then
you should also change the secrets.


## Preview

[![git-secret terminal preview](https://asciinema.org/a/41811.png)](https://asciinema.org/a/41811?autoplay=1)


## Installation

`git-secret` supports `brew`, just type: `brew install git-secret`

It also supports `apt` and `yum`. You can also use `make` if you want to. 
See the [installation section](http://git-secret.io/installation) for the details.

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

`git-secret` uses semver. See [CHANGELOG.md](CHANGELOG.md).


## Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/sobolevn/git-secret/graphs/contributors"><img src="https://opencollective.com/git-secret/contributors.svg?width=890" /></a>


## Packagers

Thanks also to all the people and groups who package git-secret to be easier to install on particular OSes or distributions!

Here are some packagings of git-secret that we're aware of:

- https://pkgs.alpinelinux.org/package/edge/testing/x86/git-secret
- https://aur.archlinux.org/packages/git-secret/
- https://packages.ubuntu.com/bionic/git-secret
- https://packages.debian.org/sid/git-secret

Such packages are considered 'downstream' because the git-secret code 'flows' from the git-secret repository 
to the various rpm/deb/dpkg/etc packages that are created for specific OSes and distributions.

We have also added notes specifically for packagers in [CONTRIBUTING.md](CONTRIBUTING.md).


## Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/git-secret#backer)]

<a href="https://opencollective.com/git-secret#backers" target="_blank"><img src="https://opencollective.com/git-secret/backers.svg?width=890"></a>


## Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/git-secret#sponsor)]

<a href="https://opencollective.com/git-secret/sponsor/0/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/1/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/2/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/3/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/4/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/5/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/6/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/7/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/8/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/git-secret/sponsor/9/website" target="_blank"><img src="https://opencollective.com/git-secret/sponsor/9/avatar.svg"></a>


## License

MIT. See [LICENSE.md](LICENSE.md) for details.


## Thanks

Special thanks to [Elio Qoshi](https://elioqoshi.me/sq/) from [ura](http://ura.design/) for the awesome logo.

---
layout: default
---

# Installation

## Dependencies

`git-secret` relies on two dependencies: `git` and `gpg`. Download and install them before using this project. `git-secret` is tested to work with:

    git version 2.7.0
    gpg (GnuPG) 1.4.20

## Supported platforms

`git-secret` works with `Mac OS X` >= 10.9, `Ubuntu` >= 14.04, `Debian` >= 8.3, and `Fedora`.
You can check the full list [here](https://travis-ci.org/sobolevn/git-secret).
You can add your platform to this list, if all the tests pass for you.
`Cygwin` support [is planned](https://github.com/sobolevn/git-secret/issues/40).

## Installation process

There are several ways to install `git-secret`:

---

### Homebrew

`brew install git-secret`

---

### `deb` package

You can find the `deb` repository [here](https://bintray.com/sobolevn/deb/git-secret).
Pre-requirements: make sure you have installed `apt-transport-https`

```bash
echo "deb https://dl.bintray.com/sobolevn/deb git-secret main" | sudo tee -a /etc/apt/sources.list
wget -qO - https://api.bintray.com/users/sobolevn/keys/gpg/public.key | sudo apt-key add -
sudo apt-get update && sudo apt-get install git-secret
```

---

### `rpm` package

You can find the `rpm` repository [here](https://bintray.com/sobolevn/rpm/git-secret).

```bash
wget https://bintray.com/sobolevn/rpm/rpm -O bintray-sobolevn-rpm.repo
sudo mv bintray-sobolevn-rpm.repo /etc/yum.repos.d/
sudo yum install git-secret
```

### Arch

You can install from the [AUR](https://aur.archlinux.org/packages/git-secret/) using your helper of choice by installing the package `git-secret` e.g. with [yay](https://github.com/Jguer/yay)

```bash
yay -S git-secret
```

---

### Manual

```bash
git clone https://github.com/sobolevn/git-secret.git git-secret
cd git-secret && make build
PREFIX="/usr/local" make install
```

Note that you can install to any prefix in your `PATH`

---

### `antigen` plugin

*Deprecated*

1. Add line `antigen bundle sobolevn/git-secret` to your `~/.zshrc`
2. Run `source ~/.zshrc` or reopen the terminal

---

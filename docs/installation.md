---
layout: default
---

# Installation

## Dependencies

`git-secret` relies on two dependencies: `git` and `gpg`. Download and install them before using this project. `git-secret` is tested to work with:

```
git version 2.7.0
gpg (GnuPG) 1.4.20
```

## Supported platforms

`git-secret` works with `Mac OS X` >= 10.9, `Ubuntu` >= 14.04, `Debian` >= 8.3, and `Fedora` / `CentOS`.
You can check the full list [here](https://github.com/sobolevn/git-secret/blob/issue-657/.github/workflows/test.yml).
You can add your platform to this list, if all the tests pass for you.
`Cygwin` support [is planned](https://github.com/sobolevn/git-secret/issues/40).

## Installation process

There are several ways to install `git-secret`:

---

### Homebrew

`brew install git-secret`

---

### `deb` package

You can find the `deb` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-deb/).
Pre-requirements: make sure you have installed `apt-transport-https` and `ca-certificates`

```bash
sudo sh -c "echo 'deb https://gitsecret.jfrog.io/artifactory/git-secret-deb git-secret main' >> /etc/apt/sources.list"
wget -qO - https://gitsecret.jfrog.io/artifactory/api/gpg/key/public | sudo apt-key add -
sudo apt-get update
sudo apt-get install git-secret
```

---

### `rpm` package

You can find the `rpm` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-rpm/).

```bash
wget https://raw.githubusercontent.com/sobolevn/git-secret/master/utils/rpm/git-secret.repo -O git-secret-rpm.repo
# Inspect what's inside! You can also enable `gpg` check on repo level.
sudo mv git-secret-rpm.repo /etc/yum.repos.d/
sudo yum install git-secret
```

### Arch Linux

The _Arch_ way to install git-secret is to use the directions for
"Installing Packages" at [Arch User Repository Documentation](https://wiki.archlinux.org/index.php/Arch_User_Repository#Installing_packages)
along with the `PKGBUILD` file from the [git-secret Arch Linux Package](https://aur.archlinux.org/packages/git-secret/)

You can also install from the [AUR](https://aur.archlinux.org/) using your helper of choice by
installing the package `git-secret`, for example using [yay](https://github.com/Jguer/yay)

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

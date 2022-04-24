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

`git-secret` is tested with `Mac OS X` >= 10.9, `Ubuntu` >= 14.04, `Debian` >= 8.3, `Fedora` / `CentOS`, and `Windows` >= 10 using `WSL`.
You can check the full list of automated test platforms
[here](https://github.com/sobolevn/git-secret/blob/master/.github/workflows/test.yml).

We are always interested in getting `git-secret` working at tested on additional systems.
If you get `git-secret` working on a new system and the tests pass for you, 
you can add a Github Action to test your platform to that file. 
Also we welcome improvements to tests or `git-secret` code for any platform.

## Installation process

There are several ways to install `git-secret`, depending on your OS and distribution.
They generally all have different installation processes, and we only go into 
a little explanation, because describing how to install the pre-requisites on all
systems is currently outside the scope of this document.

---

### Homebrew

This is a packaging system for OSX. To install `git-secret` on OSX, you can install
`homebrew` and then use:

`brew install git-secret`

---

### `deb` package

`deb` is a packaging system for [Debian](https://www.debian.org/) and related linux
distributions.

You can find the `deb` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-deb/).
Pre-requirements: make sure you have installed `apt-transport-https` and `ca-certificates`

```bash
{% include install-deb.sh %}
```

---

### `rpm` package

`rpm` is a packaging system for Fedora, CentOS, and other Red Hat based linux distributions.
You can find the `rpm` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-rpm/).

```bash
{% include install-rpm.sh %}
```

---

### Alpine

You can find the `apk` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-apk/).
See list of supported architectures [here](https://github.com/sobolevn/git-secret/blob/master/utils/apk/meta.sh)

```bash
{% include install-apk.sh %}
```

---

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

On Windows you will have to run [Git Bash](https://gitforwindows.org/) or [Mingw-w64](https://www.mingw-w64.org/) as administrator to execute 
the installation using `make`. By default, the installation will be saved to `%PROGRAMFILES%\Git\usr\local\bin` which you have to add to your `Path`
environment variable.

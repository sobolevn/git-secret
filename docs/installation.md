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
You can check the full list [here](https://github.com/sobolevn/git-secret/blob/master/.github/workflows/test.yml).
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
{% include install-deb.sh %}
```

---

### `rpm` package

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

### Windows

`git-secret` depends on many unix tools and features that Windows systems do not usually
include by default.  Therefore to get `git-secret` running on Windows you have to 
install a these tools, probably using of the toolkits described below. 
(Each has a different install and setup process).

Then, once the pre-requisite unix tools are installed,
you can use the Manual Installation instructione below to 
manually install `git-secret` (see below).  

Some options to install the required unix tools on your windows system include
WSL, CYGWIN, MSYS, and Mingw-w64 (which may have some overlap).

Documenting how each is installed and operates is beyond the scope of this document, 
so we will cover the topic in broad strokes. Improvements to this documentation
(or any other git-secret documentation) are welcome. 

Again, after you install the unix tools needed, you can install 
`git-secret` on windows using the `Manual Installation` steps below.

#### WSL

Perhaps the easiest way to get `git-secret` operating on windows is using `WSL`
(if your system supports it). 
You'll need to install these additional packages: `gnupg make man git gawk file`.
Here are instructions to install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install)

We have successfully set up automated testing of `git-secret` on `WSL`, 
so we are confident this method works.

#### Mingw-w64

One way to install the prerequisites for `git-secret` on Windows is to run 
[Mingw-w64](https://www.mingw-w64.org/) and install the needed packages.
By default, the installation will be saved to `%PROGRAMFILES%\Git\usr\local\bin` 
which you have to add to your `PATH` environment variable.
If you're using Mingw-264, you'll need to install `make` and probably other tools
such as `gnupg make man git gawk`. (This list might not be comprehensive).

#### MSYS and Cygwin

It should also be possible to use `git-secret` with (MSYS)[https://www.msys2.org/]
or (Cygwin)[https://www.cygwin.com/], we have gotten most of the way to getting
`git-secret`'s self-tests running on these setups with Windows. 
If you can help with these docs please do!
We welcome contributions to this documentation (as well as any
other git-secret docs).

---

### Manual Installation

```bash
git clone https://github.com/sobolevn/git-secret.git git-secret
cd git-secret && make build
PREFIX="/usr/local" make install
```

Note that you can change prefix to be any directory you subsequently include in in your `PATH`
environment variable. We generally recommend you stick to the the default 
install locations for simplicity, but if you know what you're doing you are welcome to change it.


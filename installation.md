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

`git-secret` is tested with `Mac OS X` >= 10.9, `Ubuntu` >= 14.04, `Debian` >= 8.3, 
`Fedora` / `Rocky Linux` / `AlmaLinux`, `FreeBSD`, and `Windows` >= 10 using `WSL`.
You can check the full list of automated test platforms
[here](https://github.com/sobolevn/git-secret/blob/master/.github/workflows/test.yml).

We are always interested in getting `git-secret` working and tested on additional systems.
If you get `git-secret` working on a new system and the tests pass for you, 
you can add a Github Action to test your platform to that file. 
Also we welcome improvements to tests or `git-secret` code for any platform.

## Installation process

There are several ways to install `git-secret`, depending on your OS and distribution.
They generally all have different installation processes, so we only go into 
a short explanation of each. 
(We welcome documentation improvements.)

---

### Mac OS X / Homebrew

This is a packaging system for OSX. To install `git-secret` on OSX, you can install
`homebrew` and then use:

```bash
brew install git-secret
````

---

### Debian-Type Systems / `deb` package

`deb` is a packaging system for [Debian](https://www.debian.org/) and related linux
distributions.

You can find the `deb` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-deb/).
Pre-requirements: make sure you have installed `apt-transport-https` and `ca-certificates`

```bash
{% include install-deb.sh %}
```

---

### Red Hat Systems / `rpm` package

`rpm` is a packaging system for Fedora, CentOS, and other Red Hat based linux distributions.
You can find the `rpm` repository [here](https://gitsecret.jfrog.io/artifactory/git-secret-rpm/).

```bash
{% include install-rpm.sh %}
```

---

### Alpine Systems / `apk` package

`apk` is a packaging system for Alpine.
You can find the `apk` `git-secret` packaging 
[here](https://gitsecret.jfrog.io/artifactory/git-secret-apk/),
and you can see a list of supported architectures 
[here](https://github.com/sobolevn/git-secret/blob/master/utils/apk/meta.sh)

```bash
{% include install-apk.sh %}
```

---

### Arch Linux / `PKGBUILD` or `AUR`

The _Arch_ way to install git-secret is to use the directions for
"Installing Packages" at [Arch User Repository Documentation](https://wiki.archlinux.org/index.php/Arch_User_Repository#Installing_packages)
along with the `PKGBUILD` file from the [git-secret Arch Linux Package](https://aur.archlinux.org/packages/git-secret/)

You can also install from the [AUR](https://aur.archlinux.org/) using your helper of choice by
installing the package `git-secret`, for example using [yay](https://github.com/Jguer/yay)

```bash
yay -S git-secret
```

---

### Windows / `WSL`, `Cygwin`, `MSYS`, or `Mingw-w64`

`git-secret` depends on many unix tools and features that Windows systems do not usually
include by default.  Therefore to get `git-secret` running on Windows you have to 
install these tools, probably using one of the toolkits described below. 
Each has a different install and setup process. There may also be other 
ways to install the unix prerequisites on Windows.

Once the prerequisite unix tools are installed,
you can use the Manual Installation instructions below to 
manually install `git-secret` (see below).  

Some ways to install the required unix tools on windows include
WSL, CYGWIN, MSYS, and Mingw-w64 
(internally, these tools may share some components).

Documenting how each is installed and used is beyond the scope of this document, 
so we will cover the topic in broad strokes. Improvements to this documentation
(or any other git-secret documentation) are welcome. 

Again, after you install the unix tools needed, you can install 
`git-secret` on windows using the `Manual Installation` steps below.

#### WSL

Perhaps the easiest way to get `git-secret` operating on windows is using `WSL`
(if your system supports it). 
Here are instructions to install [WSL](https://docs.microsoft.com/en-us/windows/wsl/install)
You'll need to install these additional packages: `gnupg`, `make`, `man`, `git`, `gawk`, `file`.

We have successfully set up automated testing of `git-secret` on `WSL`, 
so we are confident this method works.

#### Mingw-w64

Another way to install the prerequisites for `git-secret` on Windows is to use 
[Mingw-w64](https://www.mingw-w64.org/) and install the needed packages.
By default, the `Mingw-w64` installation will be saved to `C:\msys64`. You'll need to 
install `make` and probably other tools such as `gnupg`, `make`, `man`, `git`, and `gawk`. 
(This list might not be complete). 

#### MSYS and Cygwin

`git-secret` also works with [MSYS](https://www.msys2.org/)
and [Cygwin](https://www.cygwin.com/), and we have gotten _most_ of the way to getting
`git-secret`'s self-tests running on these setups with Windows (see 
[windows-related issues](https://github.com/sobolevn/git-secret/issues?q=is%3Aissue+is%3Aopen+windows)).

We welcome contributions to `git-secret` and its documentation .

---

### Manual Installation

```bash
git clone https://github.com/sobolevn/git-secret.git git-secret
cd git-secret && make build
PREFIX="/usr/local" make install
```

Note that you can change `PREFIX` to be any directory you subsequently include in in your `PATH`
environment variable. We generally recommend you stick to the the default 
install locations for simplicity, but if you know what you're doing you are welcome to change it.


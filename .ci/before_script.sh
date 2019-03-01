#!/usr/bin/env bash

set -e

# Linux helper functions:
function update_linux() {
  sudo apt-get update -qq
  sudo apt-get install -qq python-apt python-pycurl git python-pip build-essential autoconf rpm
}

function install_ansible {
  bash .ci/ansible-setup.sh
  # pyOpen, ndg-* and pyasn1 are for 'InsecurePlatformWarning' error
  ~/.avm/v2.5/venv/bin/pip install netaddr ansible-lint   pyOpenSSL ndg-httpsclient pyasn1
}


# Mac:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  brew update 

  gnupg_installed="$(brew list | grep -c "gnupg")"
  [[ "$gnupg_installed" -ge 1 ]] || brew install gnupg
  if [[ -f "/usr/local/bin/gpg1" ]]; then
    ln -s /usr/local/bin/gpg1 /usr/local/bin/gpg
  fi
  brew install gawk
fi

# Windows
if [[ "$GITSECRET_DIST" == "windows" ]]; then
  choco install gawk gnupg-modern make msys2 
  # msys2 provides bash and "is a software distro and building platform for Windows."

  # refreshenv
  # run refreshenv because choco says:
  #  "Environment Vars (like PATH) have changed. Close/reopen your shell to
  #  see the changes (or in powershell/cmd.exe just type `refreshenv`).
  # BUT when you run it, travis errors with:
  #  .ci/before_script.sh: line 35: refreshenv: command not found

  echo -n "location of bash: "
  which bash || true

  echo -n "location of env: "
  which env || true
fi

# Linux:
if [[ "$TRAVIS_OS_NAME" == "linux" ]] && [[ -n "$KITCHEN_REGEXP" ]]; then
  update_linux
  install_ansible
fi

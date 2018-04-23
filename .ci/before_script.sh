#!/usr/bin/env bash

set -e

# Linux helper functions:
function update_linux() {
  sudo apt-get update -qq
  sudo apt-get install -qq python-apt python-pycurl git python-pip ruby ruby-dev build-essential autoconf rpm  libffi-dev libssl-dev
  gem install bundler
}

function install_ansible {
  bash .ci/ansible-setup.sh
  bundle install
  ~/.avm/v2.3/venv/bin/pip install netaddr ansible-lint security 
  ~/.avm/v2.5/venv/bin/pip install netaddr ansible-lint security
}


# Mac:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  gnupg_installed="$(brew list | grep -c "gnupg")"
  [[ "$gnupg_installed" -ge 1 ]] || brew install gnupg
  if [[ -f "/usr/local/bin/gpg1" ]]; then
    ln -s /usr/local/bin/gpg1 /usr/local/bin/gpg
  fi
  brew install gawk
fi

# Linux:
if [[ "$TRAVIS_OS_NAME" == "linux" ]] && [[ -n "$KITCHEN_REGEXP" ]]; then
  update_linux
  install_ansible
fi

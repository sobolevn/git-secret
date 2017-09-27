#!/usr/bin/env bash

set -e

# Linux helper functions:
function update_linux() {
  sudo apt-get update -qq
  sudo apt-get install -qq python-apt python-pycurl git python-pip ruby ruby-dev build-essential autoconf rpm
  gem install bundler
}

function install_ansible {
  bash .ci/ansible-setup.sh
  bundle install
  ~/.avm/v2.3/venv/bin/pip install netaddr ansible-lint
  ~/.avm/v2.4/venv/bin/pip install netaddr ansible-lint
}


# Mac:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  brew install "$GITSECRET_GPG_DEP"
fi

# Linux:
if [[ "$TRAVIS_OS_NAME" == "linux" ]] && [[ -n "$KITCHEN_REGEXP" ]]; then
  update_linux
  install_ansible
fi

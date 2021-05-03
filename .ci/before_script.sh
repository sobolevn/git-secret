#!/usr/bin/env bash

set -e


# Mac:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  brew update

  gnupg_installed="$(brew list | grep -c "gnupg")"
  [[ "$gnupg_installed" -ge 1 ]] || brew install gnupg
  if [[ -f "/usr/local/bin/gpg1" ]]; then
    ln -s /usr/local/bin/gpg1 /usr/local/bin/gpg
  fi
  brew install gawk shellcheck
fi

# Windows
if [[ "$GITSECRET_DIST" == "windows" ]]; then
  choco install make shellcheck -y
fi


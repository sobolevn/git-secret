#!/usr/bin/env/bash

# shellcheck disable=SC2034
FIXTURES_DIR="$BATS_TEST_DIRNAME/../fixtures"

# reusing most of the helper from git-secret gpg tests

# shellcheck disable=SC1090
source "$BATS_TEST_DIRNAME/../_test_base.bash"

# specific sops helpers

function set_state_secret_init_sops {
  git secret init -m sops > /dev/null 2>&1
}

function set_state_secret_tell_sops_group1 {
  local email

  email="$1"
  git secret tell -d "$TEST_GPG_HOMEDIR" -g group1 "$email" > /dev/null 2>&1
}


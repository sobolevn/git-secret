#!/usr/bin/env bash

# This file is following a name convention defined in:
# https://github.com/sstephenson/bats

source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools.sh"

# Constants:

FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"

# Folders:
TEST_SECRETS_DIR="$BATS_TMPDIR/$SECRETS_DIR"
TEST_SECRETS_DIR_PATHS_MAPPING="$BATS_TMPDIR/$SECRETS_DIR_PATHS_MAPPING"

TEST_GPG_HOMEDIR="$PWD"
# TEST_TEMP_FILE="$BATS_TMPDIR/test_temp"

# GPG-based stuff:
: ${SECRETS_GPG_COMMAND:="gpg"}
GPGTEST="$SECRETS_GPG_COMMAND --homedir=$TEST_GPG_HOMEDIR --no-permission-warning"


# Personal data:
TEST_DEFAULT_USER="user1"

function test_user_password {
  echo "${1}pass"
}


function test_user_email {
  echo "${1}@gitsecret.io"
}



# GPG:

function _get_gpg_fingerprint_by_email {
  local email="$1"
  local fingerprint=$($GPGTEST --list-public-keys --with-fingerprint --with-colons | \
    sed -e '/<'$email'>::scESC:/,/[A-Z0-9]\{40\}:/!d' | \
    sed -e '/fpr/!d' | \
    sed -n 's/fpr:::::::::\([A-Z|0-9]\{40\}\):/\1/p')
  echo $fingerprint
}


function install_fixture_key {
  local public_key="$BATS_TMPDIR/public-${1}.key"
  local email=$(test_user_email "$1")

  $SECRETS_GPG_COMMAND --homedir="$FIXTURES_DIR/gpg/${1}" \
    --no-permission-warning --output "$public_key" \
    --armor --batch --yes --export "$email"  > /dev/null 2>&1
  $GPGTEST --import "$public_key" > /dev/null 2>&1
  rm -f "$public_key"
}


function install_fixture_full_key {
  local private_key="$BATS_TMPDIR/private-${1}.key"
  local email=$(test_user_email "$1")

  # local fingerprint=`_get_gpg_fingerprint_by_email "$email"`
  $SECRETS_GPG_COMMAND --homedir="$FIXTURES_DIR/gpg/${1}" \
    --no-permission-warning --output "$private_key" --armor \
    --yes --export-secret-key "$email" > /dev/null 2>&1

  $GPGTEST --allow-secret-key-import --import "$private_key" > /dev/null 2>&1

  install_fixture_key "$1"
}


function uninstall_fixture_key {
  local email=$(test_user_email "$1")
  $GPGTEST --batch --yes --delete-key "$email" > /dev/null 2>&1
}


function uninstall_fixture_full_key {
  local email=$(test_user_email "$1")
  local fingerprint=$(_get_gpg_fingerprint_by_email "$email")
  $GPGTEST --batch --yes --delete-secret-keys "$fingerprint" > /dev/null 2>&1

  uninstall_fixture_key "$1"
}


# Git:
function git_set_config_email {
  git config --local user.email "$1"
}


function git_restore_default_email {
  git config --local user.email "$1"
}


function remove_git_repository {
  rm -rf ".git"
}


# Git Secret:
function set_state_git {
  git init > /dev/null 2>&1
}


function set_state_secret_init {
  git secret init > /dev/null 2>&1
}


function set_state_secret_tell {
  local email=$(test_user_email $1)
  git secret tell -d "$TEST_GPG_HOMEDIR" "$email" > /dev/null 2>&1
}


function set_state_secret_add {
  local filename="$1"
  local content="$2"
  echo "$content" > "$filename"
  echo "$filename" >> ".gitignore"

  git secret add "$filename" > /dev/null 2>&1
}


function set_state_secret_hide {
  git secret hide > /dev/null 2>&1
}


function unset_current_state {
  # states order:
  # git, secret_init, secret_tell, secret_add, secret_hide

  # unsets `secret_hide`
  # removes .secret files:
  git secret clean > /dev/null 2>&1

  # unsets `secret_add`, `secret_tell` and `secret_init`
  rm -rf "$SECRETS_DIR"
  rm -rf ".gitignore"

  # unsets `git` state
  remove_git_repository

  # removes gpg homedir:
  rm -f "pubring.gpg" "pubring.gpg~" "secring.gpg" "trustdb.gpg" "random_seed"
}

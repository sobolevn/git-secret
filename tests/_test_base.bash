#!/usr/bin/env bash

# This file is following a name convention defined in:
# https://github.com/sstephenson/bats

# shellcheck disable=1090
source "$SECRET_PROJECT_ROOT/src/version.sh"
# shellcheck disable=1090
source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools.sh"

# Constants:
FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"

TEST_GPG_HOMEDIR="$BATS_TMPDIR"

# GPG-based stuff:
: "${SECRETS_GPG_COMMAND:="gpg"}"

# This command is used with absolute homedir set and disabled warnings:
GPGTEST="$SECRETS_GPG_COMMAND --homedir=$TEST_GPG_HOMEDIR --no-permission-warning"


# Personal data:

TEST_DEFAULT_USER="user1"
TEST_SECOND_USER="user2" # shellcheck disable=2034
TEST_ATTACKER_USER="attacker1" # shellcheck disable=2034

function test_user_password {
  # It was set on key creation:
  echo "${1}pass"
}


function test_user_email {
  # It was set on key creation:
  echo "${1}@gitsecret.io"
}


# GPG:

function get_gpg_fingerprint_by_email {
  local email="$1"
  local fingerprint

  fingerprint=$($GPGTEST --list-public-keys --with-fingerprint --with-colons | \
    sed -e '/<'"$email"'>::scESC:/,/[A-Z0-9]\{40\}:/!d' | \
    sed -e '/fpr/!d' | \
    sed -n 's/fpr:::::::::\([A-Z|0-9]\{40\}\):/\1/p')
  echo "$fingerprint"
}


function install_fixture_key {
  local public_key="$BATS_TMPDIR/public-${1}.key"
  local email

  email=$(test_user_email "$1")

  $SECRETS_GPG_COMMAND --homedir="$FIXTURES_DIR/gpg/${1}" \
    --no-permission-warning --output "$public_key" \
    --armor --batch --yes --export "$email" > /dev/null 2>&1
  $GPGTEST --import "$public_key" > /dev/null 2>&1
  rm -f "$public_key"
}


function install_fixture_full_key {
  local private_key="$BATS_TMPDIR/private-${1}.key"
  local email
  local fp
  local fingerprint

  email=$(test_user_email "$1")

  $SECRETS_GPG_COMMAND --homedir="$FIXTURES_DIR/gpg/${1}" \
    --no-permission-warning --output "$private_key" --armor \
    --yes --export-secret-key "$email" > /dev/null 2>&1

  $GPGTEST --allow-secret-key-import \
    --import "$private_key" > /dev/null 2>&1

  fp=$($GPGTEST --with-fingerprint "$private_key")

  # since 0.1.2 fingerprint is returned:
  fingerprint=$(echo "$fp" | tr -d ' ' | sed -n '2p' | sed -e 's/.*=//g')

  install_fixture_key "$1"

  # return fingerprint to delete it later:
  echo "$fingerprint"
}


function uninstall_fixture_key {
  local email

  email=$(test_user_email "$1")
  $GPGTEST --batch --yes --delete-key "$email" > /dev/null 2>&1
}


function uninstall_fixture_full_key {
  local email
  email=$(test_user_email "$1")

  local fingerprint="$2"
  if [[ -z "$fingerprint" ]]; then
    # see issue_12, fingerprint on `gpg2` has different format:
    fingerprint=$(get_gpg_fingerprint_by_email "$email")
  fi

  $GPGTEST --batch --yes \
    --delete-secret-keys "$fingerprint" > /dev/null 2>&1

  uninstall_fixture_key "$1"
}


# Git:

function git_set_config_email {
  git config --local user.email "$1"
}


function git_commit {
  git_set_config_email "$1"

  local user_name
  local commit_gpgsign

  user_name=$(git config user.name)

  commit_gpgsign=$(git config commit.gpgsign)

  git config --local user.name "$TEST_DEFAULT_USER"
  git config --local commit.gpgsign false

  git add --all
  git commit -m "$2"

  git config --local user.name "$user_name"
  git config --local commit.gpgsign "$commit_gpgsign"
}


function remove_git_repository {
  rm -rf ".git"
}


# Git Secret:

function set_state_initial {
  cd "$BATS_TMPDIR" || exit 1
  rm -rf "${BATS_TMPDIR:?}/*"
}


function set_state_git {
  git init > /dev/null 2>&1
}


function set_state_secret_init {
  git secret init > /dev/null 2>&1
}


function set_state_secret_tell {
  local email

  email=$(test_user_email "$1")
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
  # initial, git, secret_init, secret_tell, secret_add, secret_hide

  # unsets `secret_hide`
  # removes .secret files:
  git secret clean > /dev/null 2>&1

  # unsets `secret_add`, `secret_tell` and `secret_init` by removing $_SECRETS_DIR
  local secrets_dir
  secrets_dir=$(_get_secrets_dir)

  rm -rf "$secrets_dir"
  rm -rf ".gitignore"

  # unsets `git` state
  remove_git_repository

  # removes gpg homedir:
  rm -f "pubring.gpg" "pubring.gpg~" "secring.gpg" "trustdb.gpg" "random_seed"

  # return to the base dir:
  cd "$SECRET_PROJECT_ROOT" || exit 1
}

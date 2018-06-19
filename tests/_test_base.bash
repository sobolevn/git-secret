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

AWK_GPG_GET_FP='
BEGIN { OFS=":"; FS=":"; }
{
  if ( $1 == "fpr" )
  {
    print $10
    exit
  }
}
'

# GPG-based stuff:
: "${SECRETS_GPG_COMMAND:="gpg"}"

# This command is used with absolute homedir set and disabled warnings:
GPGTEST="$SECRETS_GPG_COMMAND --homedir=$TEST_GPG_HOMEDIR --no-permission-warning --batch"


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

function stop_gpg_agent {
  local username=$(id -u -n)
  ps -wx -U "$username" | gawk \
    '/gpg-agent --homedir/ { if ( $0 !~ "awk" ) { system("kill -9 "$1) } }' \
    > /dev/null 2>&1
}


function get_gpgtest_prefix {
  if [[ $GPG_VER_21 -eq 1  ]]; then
    echo "echo \"$(test_user_password $1)\" | "
  else
    echo ""
  fi
}


function get_gpg_fingerprint_by_email {
  local email="$1"
  local fingerprint

  fingerprint=$($GPGTEST --with-fingerprint \
                         --with-colon \
                         --list-secret-key $email | gawk "$AWK_GPG_GET_FP")
  echo "$fingerprint"
}


function install_fixture_key {
  local public_key="$BATS_TMPDIR/public-${1}.key"

  \cp "$FIXTURES_DIR/gpg/${1}/public.key" "$public_key"
  $GPGTEST --import "$public_key" > /dev/null 2>&1
  rm -f "$public_key"
}


function install_fixture_full_key {
  local private_key="$BATS_TMPDIR/private-${1}.key"
  local gpgtest_prefix="$(get_gpgtest_prefix $1)"
  local gpgtest_import="$gpgtest_prefix $GPGTEST"
  local email
  local fp
  local fingerprint

  email=$(test_user_email "$1")

  \cp "$FIXTURES_DIR/gpg/${1}/private.key" "$private_key"

  bash -c "$gpgtest_import --allow-secret-key-import \
    --import \"$private_key\"" > /dev/null 2>&1

  # since 0.1.2 fingerprint is returned:
  fingerprint=$(get_gpg_fingerprint_by_email $email)

  install_fixture_key "$1"

  rm -f "$private_key"
  # return fingerprint to delete it later:
  echo "$fingerprint"
}


function uninstall_fixture_key {
  local email

  email=$(test_user_email "$1")
  $GPGTEST --yes --delete-key "$email" > /dev/null 2>&1
}


function uninstall_fixture_full_key {
  local email
  email=$(test_user_email "$1")

  local fingerprint="$2"
  if [[ -z "$fingerprint" ]]; then
    # see issue_12, fingerprint on `gpg2` has different format:
    fingerprint=$(get_gpg_fingerprint_by_email "$email")
  fi

  $GPGTEST --yes \
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

  # stop gpg-agent
  stop_gpg_agent

  # removes gpg homedir:
  find "$TEST_GPG_HOMEDIR" \
    -regex ".*\/random_seed\|.*\.gpg\|.*\.kbx.?\|.*private-keys.*\|.*test_sub_dir\|.*S.gpg-agent\|.*file_to_hide.*" \
    -exec rm -rf {} +

  # return to the base dir:
  cd "$SECRET_PROJECT_ROOT" || exit 1
}

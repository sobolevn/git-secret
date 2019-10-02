#!/usr/bin/env bash

# This file is following a name convention defined in:
# https://github.com/bats-core/bats-core

# shellcheck disable=SC1090
source "$SECRET_PROJECT_ROOT/src/version.sh"
# shellcheck disable=SC1090
source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools.sh"
source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools_freebsd.sh"
source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools_linux.sh"
source "$SECRET_PROJECT_ROOT/src/_utils/_git_secret_tools_osx.sh"

# Constants:
FIXTURES_DIR="$BATS_TEST_DIRNAME/fixtures"

TEST_GPG_HOMEDIR="$BATS_TMPDIR"

# TODO: factor out tempdir creation. On osx TEST_GPG_OUTPUT_FILE, still has 'XXXXXX's, like
#   /var/folders/mm/_f0j67x10l92b4zznyx4ylzh00017w/T/gitsecret_output.XXXXXX.RaqyGYqL
TEST_GPG_OUTPUT_FILE=$(TMPDIR="$BATS_TMPDIR" mktemp -t 'gitsecret_output.XXXXXX')
#echo "# TEST_GPG_OUTPUT_FILE=$TEST_GPG_OUTPUT_FILE" >&3

# shellcheck disable=SC2016
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

# Test key fixture data. Fixtures are at tests/fixtures/gpg/$email

# See tests/fixtures/gpg/README.md for more on key fixtures 'user[1-5]@gitsecret.io'
# these two are 'normal' keys. 
export TEST_DEFAULT_USER="user1@gitsecret.io"
export TEST_SECOND_USER="user2@gitsecret.io"

# TEST_NONAME_USER (user3) created with '--quick-key-generate' and has only an email, no username.
export TEST_NONAME_USER="user3@gitsecret.io"

# TEST_EXPIRED_USER (user4) has expired
export TEST_EXPIRED_USER="user4@gitsecret.io"    # this key expires 2018-09-24

export TEST_NOEMAIL_COMMENT_USER="user5@gitsecret.io"    # fixture filename is named this, but key has no email and a comment, as per #527

export TEST_ATTACKER_USER="attacker1@gitsecret.io"


export TEST_DEFAULT_FILENAME="space file" # has spaces
export TEST_SECOND_FILENAME="space file two" # has spaces
export TEST_THIRD_FILENAME="space file three"  # has spaces


function test_user_password {
  # Password for 'user3@gitsecret.io' is 'user3pass'
  # As it was set on key creation. 
  # shellcheck disable=SC2001
  echo "$1" | sed -e 's/@.*/pass/' 
}



# GPG:

function stop_gpg_agent {
  local username
  username=$(id -u -n)
  if [[ "$GITSECRET_DIST" == "windows" ]]; then
    ps -l -u "$username" | gawk \
      '/gpg-agent/ { if ( $0 !~ "awk" ) { system("kill "$1) } }' >> "$TEST_GPG_OUTPUT_FILE" 2>&1
  else
    local ps_is_busybox
    ps_is_busybox=_exe_is_busybox "ps"
    if [[ $ps_is_busybox -eq "1" ]]; then
      echo "# git-secret: tests: not stopping gpg-agent on busybox" >&3
    else
      ps -wx -U "$username" | gawk \
        '/gpg-agent --homedir/ { if ( $0 !~ "awk" ) { system("kill "$1) } }' >> "$TEST_GPG_OUTPUT_FILE" 2>&1
    fi
  fi
}


function get_gpgtest_prefix {
  if [[ $GPG_VER_21 -eq 1  ]]; then
    # shellcheck disable=SC2086
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
                         --list-secret-key "$email" | gawk "$AWK_GPG_GET_FP")
  echo "$fingerprint"
}


function install_fixture_key {
  local public_key="$BATS_TMPDIR/public-${1}.key"

  cp "$FIXTURES_DIR/gpg/${1}/public.key" "$public_key"
  $GPGTEST --import "$public_key" >> "$TEST_GPG_OUTPUT_FILE" 2>&1
  rm -f "$public_key" || _abort "Couldn't delete public key: $public_key"
}


function install_fixture_full_key {
  local private_key="$BATS_TMPDIR/private-${1}.key"
  local gpgtest_prefix
  gpgtest_prefix=$(get_gpgtest_prefix "$1") 
  local gpgtest_import="$gpgtest_prefix $GPGTEST"
  local email
  local fingerprint

  email="$1"

  cp "$FIXTURES_DIR/gpg/${1}/private.key" "$private_key"

  bash -c "$gpgtest_import --allow-secret-key-import \
    --import \"$private_key\"" >> "${TEST_GPG_OUTPUT_FILE}" 2>&1

  # since 0.1.2 fingerprint is returned:
  fingerprint=$(get_gpg_fingerprint_by_email "$email")

  install_fixture_key "$1"

  rm -f "$private_key" || _abort "Couldn't delete private key: $private_key"
  # return fingerprint to delete it later:
  echo "$fingerprint"
}


function uninstall_fixture_key {
  local email

  email="$1"
  $GPGTEST --yes --delete-key "$email" >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function uninstall_fixture_full_key {
  local email
  email="$1"

  local fingerprint="$2"
  if [[ -z "$fingerprint" ]]; then
    # see issue_12, fingerprint on `gpg2` has different format:
    fingerprint=$(get_gpg_fingerprint_by_email "$email")
  fi

  $GPGTEST --yes --delete-secret-keys "$fingerprint" >> "$TEST_GPG_OUTPUT_FILE" 2>&1

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
  git init >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function set_state_secret_init {
  git secret init >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function set_state_secret_tell {
  local email

  email="$1"
  git secret tell -f -d "$TEST_GPG_HOMEDIR" "$email" >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function set_state_secret_add {
  local filename="$1"
  local content="$2"
  echo "$content" > "$filename"      # we add a newline
  echo "$filename" >> ".gitignore"

  git secret add "$filename" >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}

function set_state_secret_add_without_newline {
  local filename="$1"
  local content="$2"
  echo -n "$content" > "$filename"      # we do not add a newline
  echo "$filename" >> ".gitignore"

  git secret add "$filename" >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function set_state_secret_hide {
  git secret hide >> "$TEST_GPG_OUTPUT_FILE" 2>&1
}


function unset_current_state {
  # states order:
  # initial, git, secret_init, secret_tell, secret_add, secret_hide

  # unsets `secret_hide`
  # removes .secret files:
  git secret clean >> "$TEST_GPG_OUTPUT_FILE" 2>&1

  # unsets `secret_add`, `secret_tell` and `secret_init` by removing $_SECRETS_DIR
  local secrets_dir
  secrets_dir=$(_get_secrets_dir)

  rm -rf "$secrets_dir"
  rm -rf ".gitignore"

  # unsets `git` state
  remove_git_repository

  # stop gpg-agent
  stop_gpg_agent

  # SECRETS_TEST_VERBOSE is experimental
  if [[ -n "$SECRETS_TEST_VERBOSE" ]]; then 
    # display the captured output as bats diagnostic (fd3, preceded by '# ')
    sed "s/^/# $BATS_TEST_DESCRIPTION: /" < "$TEST_GPG_OUTPUT_FILE" >&3

    # display the last $output
    # shellcheck disable=SC2001,SC2154
    echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' final output: /" >&3
  fi

  rm "$TEST_GPG_OUTPUT_FILE"

  ## old code to remove tmp gpg homedir: TODO: remove.
  #find "$TEST_GPG_HOMEDIR" \
  #  -regex ".*\/random_seed\|.*\.gpg\|.*\.kbx.?\|.*private-keys.*\|.*test_sub_dir\|.*S.gpg-agent\|.*file_to_hide.*" \
  #  -exec rm -rf {} +

  # new code to remove temporary gpg homedir artifacts. 
  # For #360, 'find and rm only relevant files when test fails'.
  # ${VAR:?} will cause command to fail if VAR is 0 length, as per shellcheck SC2115
  rm -vrf "${TEST_GPG_HOMEDIR:?}/private-keys*" 2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/*.kbx"         2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/*.kbx~"        2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/*.gpg"         2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/${TEST_DEFAULT_FILENAME}"  2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/${TEST_SECOND_FILENAME}"   2>&1 | sed 's/^/# unset_current_state: rm /'
  rm -vrf "${TEST_GPG_HOMEDIR:?}/${TEST_THIRD_FILENAME}"    2>&1 | sed 's/^/# unset_current_state: rm /'

  # return to the base dir:
  cd "$SECRET_PROJECT_ROOT" || exit 1
}

# show output if we wind up manually removing the test output file in a trap
trap 'if [[ -f "$TEST_GPG_OUTPUT_FILE" ]]; then if [[ -n "$SECRETS_TEST_VERBOSE" ]]; then echo "git-secret: test: cleaning up: $TEST_GPG_OUTPUT_FILE"; fi; rm -f "$TEST_GPG_OUTPUT_FILE"; fi;' EXIT


#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_hide
}


function teardown {
  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
}


@test "run 'cat' with password argument" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE" 

  [ "$status" -eq 0 ]

  # $output is the output from 'git secret cat' above
  [ "$FILE_CONTENTS" == "$output" ]
}

@test "run 'cat' with password argument and SECRETS_VERBOSE=1" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  SECRETS_VERBOSE=1 run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE" 

  [ "$status" -eq 0 ]

  # $output _contains_ the output from 'git secret cat', may have extra output from gpg
  [[ "$output" == *"$FILE_CONTENTS"* ]]
}

@test "run 'cat' with wrong filename" {
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" NO_SUCH_FILE
  [ "$status" -eq 2 ]
}
@test "run 'cat' with bad arg" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret cat -Z -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE" 
  [ "$status" -ne 0 ]
}



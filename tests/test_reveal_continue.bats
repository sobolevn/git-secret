#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
FILE_TO_HIDE2="$TEST_SECOND_FILENAME"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_add "$FILE_TO_HIDE2" "$FILE_CONTENTS"
  set_state_secret_hide
}


function teardown {
  rm "$FILE_TO_HIDE"
  rm "$FILE_TO_HIDE2"

  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
}

@test "run 'reveal' with missing input file and -F" {
  rm "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret reveal -F

  [ "$status" -eq 0 ]
  [ -f "$FILE_TO_HIDE" ]
}


@test "run 'reveal' missing input file" {
  rm "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret reveal -F

  [ "$status" -ne 0 ]
  [ -f "$FILE_TO_HIDE" ]
}



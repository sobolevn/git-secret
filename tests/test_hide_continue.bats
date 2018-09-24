#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
FILE_TO_HIDE2="$TEST_SECOND_FILENAME"
FILE_CONTENTS="hidden content юникод"


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_add "$FILE_TO_HIDE2" "$FILE_CONTENTS"
}


function teardown {
  rm "$FILE_TO_HIDE"
  rm "$FILE_TO_HIDE2"

  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}

@test "run 'hide -F' with missing input file" {
  run git secret hide -F

  # Command must execute normally:
  [ "$status" -eq 0 ]
  [ "$output" = "done. all 2 files are hidden." ]

  # New files should be created:
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  [ -f "$encrypted_file" ]
}

#@test "run 'reveal' with missing input file and -F" {
#  rm "$FILE_TO_HIDE"
#
#  local password=$(test_user_password "$TEST_DEFAULT_USER")
#  run git secret reveal -F
#
#  [ "$status" -eq 0 ]
#  #[ -f "$FILE_TO_HIDE" ]
#}


@test "run 'reveal -F' with missing input file" {
  rm "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret reveal -P -d "$TEST_GPG_HOMEDIR" -p "$password" -F

  [ "$status" -ne 0 ]
  [ -f "$FILE_TO_HIDE" ]
}



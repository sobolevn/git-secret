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
  rm "$FILE_TO_HIDE2"
  run git secret hide -F
  echo "# output of 'git secret hide -F' is: $output" >&3

  # Command must execute normally:
  [ "$status" -eq 0 ]
  #[ "$output" = "done. 1 files are hidden." ]

  # this secret file should be created:
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  [ -f "$encrypted_file" ]

  # secret file for missing file should not be created:
  local encrypted_file2=$(_get_encrypted_filename "$FILE_TO_HIDE2")
  [ ! -f "$encrypted_file2" ]
}


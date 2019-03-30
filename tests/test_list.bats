#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="file_to_hide"
FILE_CONTENTS="hidden content юникод"


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
}


function teardown {
  rm "$FILE_TO_HIDE"

  uninstall_fixture_key $TEST_DEFAULT_USER
  unset_current_state
}


@test "run 'list' normally" {
  run git secret list
  [ "$status" -eq 0 ]
  [ "$output" = "$FILE_TO_HIDE" ]
}

@test "run 'list' with extra filename" {
  run git secret list extra_filename
  [ "$status" -ne 0 ]
}

@test "run 'list' with bad arg" {
  run git secret list -Z
  [ "$status" -ne 0 ]
}

@test "run 'list' with multiple files" {
  # Preparations:
  local second_file="second_file.txt"
  set_state_secret_add "$second_file" "$FILE_CONTENTS"

  run git secret list
  [ "$status" -eq 0 ]

  # Now it should list two files:
  [[ "$output" == *"$FILE_TO_HIDE"* ]]
  [[ "$output" == *"$second_file"* ]]

  # Cleaning up:
  rm "$second_file"
}


@test "run 'list' on empty repo" {
  git secret remove "$FILE_TO_HIDE"

  # Running `list` on empty mapping should result an error:
  run git secret list
  [ "$status" -eq 1 ]
}

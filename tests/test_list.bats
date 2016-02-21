#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="file_to_hide"
FILE_CONTENTS="hidden content юникод"


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
}


function teardown {
  uninstall_fixture_key $TEST_DEFAULT_USER
  unset_current_state

  rm -f "$FILE_TO_HIDE"
}


@test "run 'list' normally" {
  run git secret list
  [ "$status" -eq 0 ]
  [ "$output" = "$FILE_TO_HIDE" ]
}


@test "run 'list' on empty repo" {
  git secret remove "$FILE_TO_HIDE"

  run git secret list
  [ "$status" -eq 1 ]
}

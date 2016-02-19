#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  install_fixture_key "user2"

  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_tell "user2"
}


function teardown {
  uninstall_fixture_key $TEST_DEFAULT_USER
  unset_current_state

  rm -f "$FILE_TO_HIDE"
}


@test "run 'whoknows' normally" {
  run git secret whoknows
  [ "$status" -eq 0 ]
}

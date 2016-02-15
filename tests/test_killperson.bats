#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"

  # init_git_repository
  # git_secret_init
  # git_secret_tell_test
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


@test "run 'killperson' without arguments" {
  run git secret killperson
  [ "$status" -eq 1 ]
}


@test "run 'killperson' normally" {
  run git secret killperson "$TEST_DEFAULT_USER"
  [ "$status" -eq 0 ]
}

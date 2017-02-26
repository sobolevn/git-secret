#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
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

  # Then whoknows must return an error with status code 1:
  run git secret whoknows
  [ "$status" -eq 1 ]
}


@test "run 'killperson' with multiple arguments" {
  # Adding second user:
  install_fixture_key "$TEST_SECOND_USER"
  set_state_secret_tell "$TEST_SECOND_USER"

  run git secret killperson "$TEST_DEFAULT_USER" "$TEST_SECOND_USER"
  [ "$status" -eq 0 ]

  # Nothing to show:
  run git secret whoknows
  [ "$status" -eq 1 ]
}

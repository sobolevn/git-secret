#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  install_fixture_key "$TEST_SECOND_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_tell "$TEST_SECOND_USER"
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  uninstall_fixture_key "$TEST_SECOND_USER"
  unset_current_state
}


@test "run 'whoknows' normally" {
  run git secret whoknows
  [ "$status" -eq 0 ]

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_SECOND_USER"* ]]
}


@test "run 'whoknows' without any users" {
  # Preparations, removing users:
  local email1=$(test_user_email "$TEST_DEFAULT_USER")
  local email2=$(test_user_email "$TEST_SECOND_USER")
  git secret killperson "$email1" "$email2"

  # Now whoknows should raise an error: there are no users.
  run git secret whoknows
  [ "$status" -eq 1 ]
}

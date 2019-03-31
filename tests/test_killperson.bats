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


@test "run 'killperson' with short name" {
  local name
  name=$(echo "$TEST_DEFAULT_USER" | sed -e 's/@.*//')

  # killperson must use full email, not short name
  run git secret killperson "$name"
  [ "$status" -eq 1 ]

  # Then whoknows will be ok because user3@gitsecret.io still knows
  run git secret whoknows
  [ "$status" -eq 0 ]

  # Testing output:
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
}


@test "run 'killperson' with email" {
  local email="$TEST_DEFAULT_USER"

  run git secret killperson "$email"
  [ "$status" -eq 0 ]

  # Testing output:
  [[ "$output" == *"$email"* ]]

  # Then whoknows must return an error with status code 1:
  run git secret whoknows
  [ "$status" -eq 1 ]
}


@test "run 'killperson' with multiple arguments" {
  # Adding second user:
  install_fixture_key "$TEST_SECOND_USER"
  set_state_secret_tell "$TEST_SECOND_USER"

  local default_email="$TEST_DEFAULT_USER"
  local second_email="$TEST_SECOND_USER"

  run git secret killperson "$default_email" "$second_email"
  [ "$status" -eq 0 ]

  # Testing output:
  [[ "$output" == *"$default_email"* ]]
  [[ "$output" == *"$second_email"* ]]

  # Nothing to show:
  run git secret whoknows
  [ "$status" -eq 1 ]
}

@test "run 'killperson' with bad arg" {
  local email="$TEST_DEFAULT_USER"
  run git secret killperson -Z "$email"
  [ "$status" -ne 0 ]
}


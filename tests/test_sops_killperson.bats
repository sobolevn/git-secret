#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init_sops
  set_state_secret_tell "$TEST_DEFAULT_USER"
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


@test "run 'killperson' with short name and sops" {
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

  # check that person is still in sops config
  run _get_id_group "pgp" "$TEST_DEFAULT_USER"
  [[ "$output" == "default" ]]
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

  # check that person is not in sops config
  run _get_id_group "pgp" "$TEST_DEFAULT_USER"
  [[ "$output" == "" ]]
}

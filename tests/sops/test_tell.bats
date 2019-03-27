#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init_sops
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}

@test "run 'tell' normally with sops" {

  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 0 ]

  # Testing that now user is found:
  run _user_required
  [ "$status" -eq 0 ]

  # Testing that now user is in the list of people who knows the secret:
  run git secret whoknows
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]

  # Testing that user is in default group
  run _get_id_group "pgp" "$TEST_DEFAULT_USER"
  [[ "$output" == "default" ]]
}

@test "run 'tell' normally with sops and test group" {

  run git secret tell -d "$TEST_GPG_HOMEDIR" -g "test" "$TEST_DEFAULT_USER"
  [ "$status" -eq 0 ]

  # Testing that now user is found:
  run _user_required
  [ "$status" -eq 0 ]

  # Testing that now user is in the list of people who knows the secret:
  run git secret whoknows
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]

  # Testing that user is in test group
  run _get_id_group "pgp" "$TEST_DEFAULT_USER"
  [[ "$output" == "test" ]]
}

@test "run 'tell' with multiple emails with sops" {

  # Preparations:
  install_fixture_key "$TEST_SECOND_USER"

  # Testing the command itself:
  run git secret tell -d "$TEST_GPG_HOMEDIR" \
    "$TEST_DEFAULT_USER" "$TEST_SECOND_USER"

  [ "$status" -eq 0 ]

  # Testing that these users are presented in the
  # list of people who knows secret:
  run git secret whoknows

  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_SECOND_USER"* ]]

  # Testing that users are in default group
  run _get_id_group "pgp" "$TEST_DEFAULT_USER"
  [[ "$output" == "default" ]]
  run _get_id_group "pgp" "$TEST_SECOND_USER"
  [[ "$output" == "default" ]]

  # Cleaning up:
  uninstall_fixture_key "$TEST_SECOND_USER"
}

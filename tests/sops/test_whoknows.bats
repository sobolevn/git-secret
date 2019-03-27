#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  install_fixture_key "$TEST_SECOND_USER"

  set_state_initial
  set_state_git
  set_state_secret_init_sops
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_tell "$TEST_SECOND_USER"
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  uninstall_fixture_key "$TEST_SECOND_USER"
  unset_current_state
}

@test "run 'whoknows -l' with sops" {

  run git secret whoknows -l
  [ "$status" -eq 0 ]

  #echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3
    # output should look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  #echo "# '$BATS_TEST_DESCRIPTION' status: $status" >&3

  # Now test the output, both users should be present and without expiration
  [[ "$output" == *"$TEST_DEFAULT_USER (expires: never) - group: default"* ]]
  [[ "$output" == *"$TEST_SECOND_USER (expires: never) - group: default"* ]]
}

#!/usr/bin/env bats

load _test_base

function setup {
  install_fixture_key "$TEST_EXPIRED_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_EXPIRED_USER"
}

function teardown {
  uninstall_fixture_key "$TEST_EXPIRED_USER"
  unset_current_state
}

@test "test 'hide' using expired key" {
  FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
  FILE_CONTENTS="hidden content юникод"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"

  run git secret hide   
  # this will fail, because we're using an expired key

  echo "# output of hide: $output" >&3
    # output will look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  #echo "# status of hide: $status" >&3

  [ $status -ne 0 ] # we expect failure here. Actual code is 2
}


@test "run 'whoknows -l' on only expired user" {
  run git secret whoknows -l
  [ "$status" -eq 0 ]

  # diag output for bats-core
  echo "# output of 'whoknows -l: $output" >&3
  echo >&3
    # output should look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  #echo "# status of hide: $status" >&3

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_EXPIRED_USER"* ]]
}



@test "run 'whoknows -l' on expired and normal user" {
  install_fixture_key "$TEST_DEFAULT_USER"
  set_state_secret_tell "$TEST_DEFAULT_USER"

  run git secret whoknows -l
  [ "$status" -eq 0 ]

  echo $output | sed 's/^/# whoknows -l: /' >&3
  echo >&3

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_EXPIRED_USER"* ]]

  uninstall_fixture_key "$TEST_DEFAULT_USER"
}

function teardown {
  uninstall_fixture_key "$TEST_EXPIRED_USER"
  unset_current_state
}

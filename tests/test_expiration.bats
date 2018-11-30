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
  #echo "# output of hide: $output" >&3
  #echo "# status of hide: $status" >&3
  [ $status -ne 0 ] # we expect failure here. Actual code is 2
}



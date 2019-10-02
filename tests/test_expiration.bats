#!/usr/bin/env bats

export TZ="GMT"

load _test_base

function setup {
  install_fixture_key "$TEST_EXPIRED_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
}

function teardown {
  uninstall_fixture_key "$TEST_EXPIRED_USER"
  unset_current_state
}

@test "test 'tell' using expired key" {
  run git secret tell "$TEST_EXPIRED_USER"
  [ $status -ne 0 ] # failure here because we'd need to use 'tell -f' with expired key
}

@test "test 'hide' using expired key forced with 'tell -f'" {
  FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
  FILE_CONTENTS="hidden content юникод"
  set_state_secret_tell_force "$TEST_EXPIRED_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"

  run git secret hide   
  # this will fail, because keychain has an expired key

  #echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3
    # output will look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  #echo "# status of hide: $status" >&3

  [ $status -ne 0 ] # we expect failure here. 
}


@test "run 'whoknows -l' on expired key forced with 'tell -f'" {
  set_state_secret_tell_force "$TEST_EXPIRED_USER"
  run git secret whoknows -l
  [ "$status" -eq 0 ]

  # diag output for bats-core
  #echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3
  # output should look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  
  #echo "# $BATS_TEST_DESCRIPTION: $status" >&3

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_EXPIRED_USER (expires: 2018-09-23)"* ]]
}



@test "run 'whoknows -l' on normal key and forced expired key" {
  set_state_secret_tell_force "$TEST_EXPIRED_USER"
  install_fixture_key "$TEST_DEFAULT_USER"
  set_state_secret_tell "$TEST_DEFAULT_USER"

  run git secret whoknows -l
  [ "$status" -eq 0 ]

  #echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_DEFAULT_USER (expires: never)"* ]]
  [[ "$output" == *"$TEST_EXPIRED_USER (expires: 2018-09-23)"* ]]

  uninstall_fixture_key "$TEST_DEFAULT_USER"
}

function teardown {
  uninstall_fixture_key "$TEST_EXPIRED_USER"
  unset_current_state
}

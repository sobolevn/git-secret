#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="file_to_hide"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_hide
}


function teardown {
  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
}


@test "run 'cat' with password argument" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE" 

  #[[ "$status" -eq 0 ]]

  # $output is the output from 'git secret cat' above
  # note that currently content may differ by a newline
  [[ "$output" == *"-$FILE_CONTENTS"* ]]
}

@test "previous output was $output (expected $FILE_CONTENTS)" {
    [ 1 ]
}

# Negative test - what happens if we 'git secret cat' no file
# test cat with no filename
@test "run 'cat' with no filename" {
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" 
  [ "$status" -eq 1 ]
}


#
# Negative test - what happens if we ask for unknown file
@test "run 'cat' with wrong filename" {
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" NO_SUCH_FILE
  [ "$status" -eq 1 ]
}


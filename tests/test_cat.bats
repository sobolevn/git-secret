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
  #rm "$FILE_TO_HIDE"

  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
}


@test "run 'cat' with password argument" {
  cp "$FILE_TO_HIDE" "${FILE_TO_HIDE}2"
  rm -f "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret cat -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE" 

  [ "$status" -eq 0 ]

  # $output is the output from 'git secret cat' above
  [ "$FILE_CONTENTS" == "$output" ]

  rm "${FILE_TO_HIDE}2"
}

@test "run 'cat' with wrong filename" {
  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "$password" NO_SUCH_FILE
  [ "$status" -eq 2 ]
}


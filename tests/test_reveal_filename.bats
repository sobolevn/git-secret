#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""
OLD_SECRETS_EXTENSION=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"

  OLD_SECRETS_EXTENSION="$SECRETS_EXTENSION"
  export SECRETS_EXTENSION=".new_secret"

  set_state_secret_hide
}


function teardown {
  rm "$FILE_TO_HIDE"

  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state

  export SECRETS_EXTENSION="$OLD_SECRETS_EXTENSION"
}


@test "run 'reveal' with different file extension" {
  cp "$FILE_TO_HIDE" "${FILE_TO_HIDE}2"
  rm "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "$password"

  [ "$status" -eq 0 ]
  [ -f "$FILE_TO_HIDE" ]

  cmp -s "$FILE_TO_HIDE" "${FILE_TO_HIDE}2"

  rm "${FILE_TO_HIDE}2"
}

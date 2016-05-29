#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="file_to_hide"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_hide
}


function teardown {
  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
  rm -f "$FILE_TO_HIDE"
}


@test "run 'changes' without previous commit" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local new_content="new content"
  echo "$new_content" >> "$FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password"
  [ "$status" -eq 0 ]

  # Testing that output has both filename and changes:
  [[ "$output" == *"$FILE_TO_HIDE"* ]]
  [[ "$output" == *"$new_content"* ]]
}


@test "run 'changes' without changes" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password"
  [ "$status" -eq 0 ]
}


@test "run 'changes' with commit" {
  git_commit "$(test_user_email $TEST_DEFAULT_USER)" 'initial'
  local password=$(test_user_password "$TEST_DEFAULT_USER")

  echo "new content" >> "$FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password"
  [ "$status" -eq 0 ]
  [[ "$output" == *"$FILE_TO_HIDE"* ]]
  [[ "$output" == *"$new_content"* ]]
}

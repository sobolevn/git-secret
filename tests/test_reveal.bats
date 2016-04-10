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


@test "run 'reveal' with password argument" {
  cp "$FILE_TO_HIDE" "${FILE_TO_HIDE}2"
  rm -f "$FILE_TO_HIDE"

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "$password"

  [ "$status" -eq 0 ]
  [ -f "$FILE_TO_HIDE" ]

  cmp --silent "$FILE_TO_HIDE" "${FILE_TO_HIDE}2"

  rm -f "${FILE_TO_HIDE}2"
}


@test "run 'reveal' with wrong password" {
  rm -f "$FILE_TO_HIDE"

  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "WRONG"
  [ "$status" -eq 2 ]
  [ ! -f "$FILE_TO_HIDE" ]
}


@test "run 'reveal' for attacker" {
  rm -f "$FILE_TO_HIDE"

  local attacker="attacker1"
  local atacker_fingerprint=$(install_fixture_full_key "$attacker")

  local password=$(test_user_password "$attacker")
  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "$password"

  [ "$status" -eq 2 ]
  [ ! -f "$FILE_TO_HIDE" ]

  uninstall_fixture_full_key "$attacker" "$atacker_fingerprint"
}


@test "run 'reveal' for multiple users" {
  local new_user="user2"
  install_fixture_full_key "$new_user"
  set_state_secret_tell "$new_user"
  set_state_secret_hide

  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"

  local password=$(test_user_password "$new_user")
  run git secret reveal -d "$TEST_GPG_HOMEDIR" -p "$password"

  [ "$status" -eq 0 ]
  [ -f "$FILE_TO_HIDE" ]
}

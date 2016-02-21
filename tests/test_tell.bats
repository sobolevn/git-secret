#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key $TEST_DEFAULT_USER
  set_state_git
  set_state_secret_init
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


function git_secret_tell_test {
  git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
}


@test "fail on no users" {
  run _user_required
  [ "$status" -eq 1 ]
}


@test "run 'tell' with secret-key imported" {
  local private_key="$SECRETS_DIR_KEYS/secring.gpg"
  echo "private key" > "$private_key"
  [ -s "$private_key" ]

  run git_secret_tell_test
  [ "$status" -eq 1 ]
}


@test "run 'tell' without '.gitsecret'" {
  rm -rf "$SECRETS_DIR"

  run git_secret_tell_test
  [ "$status" -eq 1 ]
}


@test "run 'tell' without arguments" {
  run git secret tell
  [ "$status" -eq 1 ]
}


@test "run 'tell' normally" {
  run git_secret_tell_test
  [ "$status" -eq 0 ]

  run _user_required
  [ "$status" -eq 0 ]
}


@test "run 'tell -m'" {
  email=$(test_user_email $TEST_DEFAULT_USER)

  git_set_config_email "$email"
  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 0 ]
}


@test "run 'tell -m' with empty email" {
  git_set_config_email ""
  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 1 ]
}

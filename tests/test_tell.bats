#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


@test "fail on no users" {
  run _user_required
  [ "$status" -eq 1 ]
}


@test "constantly fail on no users" {
  # We had a serious bug with _user_required,
  # see this link for the details:
  # https://github.com/sobolevn/git-secret/issues/74

  # Preparations:
  git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  git secret killperson "$TEST_DEFAULT_USER"

  # It was showing something like `tru::1:1289775241:0:2:1:6`
  # after the preparations done and the error was not generated.
  run _user_required
  [ "$status" -eq 1 ]
}


@test "run 'tell' with secret-key imported" {
  local private_key="$SECRETS_DIR_KEYS/secring.gpg"
  echo "private key" > "$private_key"
  [ -s "$private_key" ]

  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 1 ]
}


@test "run 'tell' without '.gitsecret'" {
  rm -rf "$SECRETS_DIR"

  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 1 ]
}


@test "run 'tell' without arguments" {
  run git secret tell
  [ "$status" -eq 1 ]
}


@test "run 'tell' normally" {
  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 0 ]

  # Testing that now user is found:
  run _user_required
  [ "$status" -eq 0 ]

  # Testing that now user is in the list of people who knows the secret:
  run git secret whoknows
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
}


@test "run 'tell' with '-m'" {
  email=$(test_user_email $TEST_DEFAULT_USER)

  git_set_config_email "$email"
  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 0 ]
}


@test "run 'tell' with '-m' (empty email)" {
  # Prepartions:
  git_set_config_email "" # now it should not allow to add yourself

  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 1 ]
}


@test "run 'tell' with multiple emails" {
  # Preparations:
  install_fixture_key "$TEST_SECOND_USER"

  # Testing the command iteself:
  run git secret tell -d "$TEST_GPG_HOMEDIR" \
    "$TEST_DEFAULT_USER" "$TEST_SECOND_USER"

  [ "$status" -eq 0 ]

  # Testing that these users are presented in the
  # list of people who knows secret:
  run git secret whoknows

  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_SECOND_USER"* ]]

  # Cleaning up:
  uninstall_fixture_key "$TEST_SECOND_USER"
}

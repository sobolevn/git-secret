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


@test "run 'tell' with '-v'" {
  run git secret tell -d "$TEST_GPG_HOMEDIR" -v "$TEST_DEFAULT_USER"
  # echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3

  [[ "$output" == *"created"* ]]
  [[ "$output" == *"gpg:"* ]]
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [ "$status" -eq 0 ]
}


@test "run 'tell' without '-v'" {
  run git secret tell -d "$TEST_GPG_HOMEDIR"  "$TEST_DEFAULT_USER"
  # echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3

  [[ "$output" != *"imported:"* ]]
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [ "$status" -eq 0 ]
}


@test "run 'tell' on substring of emails" {
  run git secret tell -d "$TEST_GPG_HOMEDIR" user
  # this should give an error because there is no user named 'user',
  # even though there are users with the substring 'user'.
  # See issue https://github.com/sobolevn/git-secret/issues/176
  [ "$status" -eq 1 ]

  run git secret whoknows
  [ "$status" -eq 1 ]   # should error when there are no users told

}


@test "run 'tell' on the same email twice" {
  # first time should succeed
  git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"

  # second time should fail because there's already a key for that email. See #634
  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -ne 0 ]
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
  git secret removeperson "$TEST_DEFAULT_USER"

  # It was showing something like `tru::1:1289775241:0:2:1:6`
  # after the preparations done and the error was not generated.
  run _user_required
  [ "$status" -eq 1 ]
}


@test "run 'tell' with secret-key imported" {
  local secrets_dir_keys
  secrets_dir_keys=$(_get_secrets_dir_keys)

  local private_key="$secrets_dir_keys/secring.gpg"
  echo "private key" > "$private_key"
  [ -s "$private_key" ]

  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 1 ]
}


@test "run 'tell' without '.gitsecret'" {
  local secrets_dir
  secrets_dir=$(_get_secrets_dir)

  rm -r "$secrets_dir"

  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 1 ]
}


@test "run 'tell' without arguments" {
  run git secret tell
  [ "$status" -eq 1 ]
}


@test "run 'init' with bad arg" {
  run git secret tell -Z -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -ne 0 ]
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
  local email="$TEST_DEFAULT_USER"

  git_set_config_email "$email"
  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 0 ]
}


@test "run 'tell' with '-m' (empty email)" {
  # Preparations:
  git_set_config_email "" # now it should not allow to add yourself

  run git secret tell -d "$TEST_GPG_HOMEDIR" -m
  [ "$status" -eq 1 ]
}


@test "run 'tell' with multiple emails" {
  # Preparations:
  install_fixture_key "$TEST_SECOND_USER"

  # Testing the command itself:
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


@test "run 'tell' with key without email and with comment" {
  # install works because it works on filename, not contents of keychain
  install_fixture_key "$TEST_NOEMAIL_COMMENT_USER"

  # Testing the command itself fails because you have to use an email address
  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_NOEMAIL_COMMENT_USER"

  # this should not succeed because we only support addressing users by email
  [ "$status" -ne 0 ]

  # Testing that these users are presented in the
  # list of people who knows secret:
  run git secret whoknows

  [[ "$output" != *"$TEST_NOEMAIL_COMMENT_USER"* ]]

  # Cleaning up: can't clean up by email
  # uninstall_fixture_key "$TEST_NOEMAIL_COMMENT_USER"
}


@test "run 'tell' on non-email" {
  install_fixture_key "$TEST_NOEMAIL_COMMENT_USER"

  local name
  # don't complain about sed
  # shellcheck disable=SC2001 
  name=$(echo "$TEST_NOEMAIL_COMMENT_USER" | sed -e 's/@.*//')
  # echo "$name" | sed "s/^/# '$BATS_TEST_DESCRIPTION' name is: /" >&3

  # Testing the command itself, should fail because you must use email
  run git secret tell -d "$TEST_GPG_HOMEDIR" "$name"

  # this should not succeed because we only support addressing users by email
  [ "$status" -ne 0 ]

  # Testing that these users are presented in the
  # list of people who knows secret:
  run git secret whoknows

  [[ "$output" != *"$name"* ]]

  # Cleaning up: can't clean up by email because key doesn't hold it
  # uninstall_fixture_key "$TEST_NOEMAIL_COMMENT_USER"
}

@test "run 'tell' in subfolder" {
  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    skip "this test is skipped while 'git commit'. See #334"
  fi

  # Preparations
  local root_dir='test_dir'
  local test_dir="$root_dir/telling"
  local current_dir="$PWD"

  mkdir -p "$test_dir"
  cd "$test_dir"

  # Test:
  run git secret tell -d "$TEST_GPG_HOMEDIR" "$TEST_DEFAULT_USER"
  [ "$status" -eq 0 ]

  # Testing that now user is found:
  run _user_required
  [ "$status" -eq 0 ]

  # Testing that now user is in the list of people who knows the secret:
  run git secret whoknows
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]

  # Cleaning up:
  cd "$current_dir"
  rm -r "$root_dir"
}

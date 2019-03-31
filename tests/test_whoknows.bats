#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  install_fixture_key "$TEST_SECOND_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_tell "$TEST_SECOND_USER"
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  uninstall_fixture_key "$TEST_SECOND_USER"
  unset_current_state
}


@test "run 'whoknows' normally" {
  run git secret whoknows
  [ "$status" -eq 0 ]

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_SECOND_USER"* ]]
}

@test "run 'whoknows' with extra filename" {
  run git secret whoknows extra_filename
  [ "$status" -ne 0 ]
}

@test "run 'whoknows' with bad arg" {
  run git secret whoknows -Z
  [ "$status" -ne 0 ]
}

@test "run 'whoknows -l'" {
  run git secret whoknows -l
  [ "$status" -eq 0 ]

  #echo "$output" | sed "s/^/# '$BATS_TEST_DESCRIPTION' output: /" >&3
    # output should look like 'abort: problem encrypting file with gpg: exit code 2: space file'
  #echo "# '$BATS_TEST_DESCRIPTION' status: $status" >&3

  # Now test the output, both users should be present and without expiration
  [[ "$output" == *"$TEST_DEFAULT_USER (expires: never)"* ]]
  [[ "$output" == *"$TEST_SECOND_USER (expires: never)"* ]]
}

@test "run 'whoknows' in subfolder" {
  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    skip "this test is skipped while 'git commit'. See #334"
  fi

  # Preparations:
  local current_dir=$(pwd)
  local root_dir='test_dir'
  local test_dir="$root_dir/subfolders/case"

  mkdir -p "$test_dir"
  cd "$test_dir"

  # Test:
  run git secret whoknows
  [ "$status" -eq 0 ]

  # Now test the output, both users should be present:
  [[ "$output" == *"$TEST_DEFAULT_USER"* ]]
  [[ "$output" == *"$TEST_SECOND_USER"* ]]

  # Cleaning up:
  cd "$current_dir"
  rm -r "$root_dir"
}


@test "run 'whoknows' without any users" {
  # Preparations, removing users:
  local email1="$TEST_DEFAULT_USER"
  local email2="$TEST_SECOND_USER"
  git secret killperson "$email1" "$email2"

  # Now whoknows should raise an error: there are no users.
  run git secret whoknows
  [ "$status" -eq 1 ]
}

#!/usr/bin/env bats

load _test_base


function setup {
  set_state_initial
  set_state_git
}


function teardown {
  unset_current_state
}


@test "secrets dir env var set as expected" {
  _TEST_SECRETS_DIR=${SECRETS_DIR:-".gitsecret"}   
  [ "${_TEST_SECRETS_DIR}" = "${_SECRETS_DIR}" ]
}


@test "run 'init' without '.git'" {
  remove_git_repository

  run git secret init
  [ "$status" -eq 1 ]
}


@test "run 'init' normally" {
  run git secret init
  [ "$status" -eq 0 ]

  [[ -d "${_SECRETS_DIR}" ]]
}


@test "run 'init' with extra filename" {
  run git secret init extra_filename
  [ "$status" -ne 0 ]
}

@test "run 'init' with bad arg" {
  run git secret init -Z
  [ "$status" -ne 0 ]
}


@test "run 'init' in subfolder" {
  # This test covers this issue:
  # https://github.com/sobolevn/git-secret/issues/83

  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    skip "this test is skipped while 'git commit'. See #334"
  fi

  # Preparations
  local test_dir='test_dir'
  local nested_dir="$test_dir/nested/dirs"
  local current_dir=$(pwd)

  mkdir -p "$nested_dir"
  cd "$nested_dir"

  # Test:
  run git secret init
  [ "$status" -eq 0 ]

  # It should not be created in the current folder:
  [[ ! -d "${_SECRETS_DIR}" ]]

  # It should be created here:
  local secrets_dir
  secrets_dir=$(_get_secrets_dir)
  [[ -d "$secrets_dir" ]]

  # Cleaning up:
  cd "$current_dir"
  rm -r "$test_dir"
}


@test "run 'init' with '.gitsecret' already initialized" {
  local secrets_dir
  secrets_dir=$(_get_secrets_dir)

  mkdir "$secrets_dir"

  run git secret init
  [ "$output" = "git-secret: abort: already initialized." ]
  [ "$status" -eq 1 ]
}

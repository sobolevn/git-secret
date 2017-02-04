#!/usr/bin/env bats

load _test_base


function setup {
  set_state_git
}


function teardown {
  unset_current_state
}


@test "run 'init' without .git" {
  remove_git_repository

  run git secret init
  [ "$status" -eq 1 ]
}


@test "run 'init' normally" {
  run git secret init
  [ "$status" -eq 0 ]
}


@test "run 'init' with '.gitsecret' already inited" {
  mkdir "$SECRETS_DIR"

  run git secret init
  [ "$output" = "already inited. abort." ]
  [ "$status" -eq 1 ]
}

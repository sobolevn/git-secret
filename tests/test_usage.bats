#!/usr/bin/env bats

load _test_base


function setup {
  set_state_git
}


function teardown {
  unset_current_state
}


@test "run 'usage'" {
  run git secret usage
  [ "$status" -eq 0 ]
}


@test "run 'usage' without '.git/'" {
  remove_git_repository

  run git secret usage
  [ "$status" -eq 1 ]
}


@test "run 'usage' with ignored '.gitsecret/'" {
  echo ".gitsecret/" >> ".gitignore"
  run git secret usage
  [ "$status" -eq 1 ]
}

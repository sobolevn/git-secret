#!/usr/bin/env bats

load _test_base


function setup {
  set_state_git
}


function teardown {
  unset_current_state
}


@test "run 'git secret' without command" {
  run git secret
  [ "$status" -eq 126 ]
}


@test "run 'git secret' with bad command" {
  run git secret notacommand
  [ "$status" -eq 126 ]
}

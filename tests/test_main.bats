#!/usr/bin/env bats

load _test_base


function setup {
  set_state_initial
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


@test "run 'git secret --version'" {
  run git secret --version
  [ "$output" == "$GITSECRET_VERSION" ]
}


@test "run 'git secret --dry-run'" {
  # We will break things apart, so normally it won't run:
  rm -r "./.git"

  # It's ok for 'usage' to succeed when there's no .git directory
  run git secret usage
  [ "$status" -eq 0 ]

  # Dry run won't fail:
  run git secret --dry-run
  [ "$status" -eq 0 ]
}

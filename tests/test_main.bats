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
  run_wrapper git secret
  [ "$status" -eq 126 ]
}


@test "run 'git secret' with bad command" {
  run_wrapper git secret notacommand
  [ "$status" -eq 126 ]
}


@test "run 'git secret --version'" {
  run_wrapper git secret --version
  [ "$output" == "$GITSECRET_VERSION" ]
}


@test "run 'git secret --dry-run'" {
  # We will break things apart, so normally it won't run:
  rm -r "./.git"

  # test of 'git secret usage' here removed as it's duplicated in test_usage.bats

  # Dry run_wrapper won't fail:
  run_wrapper git secret --dry-run
  [ "$status" -eq 0 ]
}

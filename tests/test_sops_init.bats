#!/usr/bin/env bats

load _test_base


function setup {
  set_state_initial
  set_state_git
}


function teardown {
  unset_current_state
}

@test "run 'init' normally in sops mode" {
  if [ "$SECRET_TEST_SOPS" != "true" ]; then
    skip "sops mode not requested for test"
  fi
  run git secret init -m sops
  [ "$status" -eq 0 ]

  run git config --get git-secret.mode
  [ "$output" = "sops" ]
  [ "$status" -eq 0 ]

  [[ -d "${_SECRETS_DIR}" ]]

  [[ -d "${_SECRETS_DIR_SOPS}" ]]
}

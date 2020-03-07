#!/usr/bin/env bats

load _test_base


function setup {
  set_state_initial
  set_state_git
}


function teardown {
  unset_current_state
}


@test "run 'usage'" {
  run git secret usage
  [ "$status" -eq 0 ]
}


@test "run 'usage' without '.git'" {
  remove_git_repository

  # It's ok for 'usage' to succeed when there's no .git directory, but it doesn't
  run git secret usage
  [ "$status" -eq 1 ]
}


#_SECRETS_DIR=${SECRETS_DIR:-".gitsecret"}   
@test "run 'usage' with ignored '${_SECRETS_DIR}'" {
  echo "${_SECRETS_DIR}" >> ".gitignore"
  
  # below shows how to send 'diagnostic' messages to bats-core.
  #echo "# clear-line-output" >&3
  #echo "# SECRETS_DIR is ${_SECRETS_DIR}" >&3

  # It's ok for 'usage' to succeed when the .gitsecret directory is ignored, but it doesn't
  run git secret usage
  #echo "# git secret usage -> status $status" >&3

  [ "$status" -eq 1 ]
}

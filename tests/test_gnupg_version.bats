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

@test "show environment variables" {
  printenv | sort | sed "s/^/# '$BATS_TEST_DESCRIPTION' printenv output: /" >&3
  [ 0 ] # force failure
}


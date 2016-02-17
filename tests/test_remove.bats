#!/usr/bin/env bats

load _test_base

FIRST_FILE="file_to_hide1"
SECOND_FILE="file_to_hide2"


function setup {
  install_fixture_full_key "$TEST_DEFAULT_USER"

  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FIRST_FILE" "$FIRST_FILE"
  set_state_secret_add "$SECOND_FILE" "$SECOND_FILE"
}


function teardown {
  uninstall_fixture_full_key "$TEST_DEFAULT_USER"
  unset_current_state
  rm -f "$FIRST_FILE" "$SECOND_FILE"
}


@test "run 'remove' normally" {
  git secret hide

  run git secret remove "$SECOND_FILE"
  echo "$output"
  [ "$status" -eq 0 ]

  local mapping_contains=$(grep "$SECOND_FILE" "$SECRETS_DIR_PATHS_MAPPING"; echo $?)
  [ "$mapping_contains" -eq 1 ]

  local first_enctypted_file=`_get_encrypted_filename $FIRST_FILE`
  local second_enctypted_file=`_get_encrypted_filename $SECOND_FILE`

  [ -f "$first_enctypted_file" ]
  [ -f "$second_enctypted_file" ]
}


@test "run 'remove -c'" {
  git secret hide

  run git secret remove -c "$SECOND_FILE"
  echo "$output"
  [ "$status" -eq 0 ]

  local mapping_contains=$(grep "$SECOND_FILE" "$SECRETS_DIR_PATHS_MAPPING"; echo $?)
  [ "$mapping_contains" -eq 1 ]

  local first_enctypted_file=`_get_encrypted_filename $FIRST_FILE`
  local second_enctypted_file=`_get_encrypted_filename $SECOND_FILE`

  [ -f "$first_enctypted_file" ]
  [ ! -f "$second_enctypted_file" ]
}

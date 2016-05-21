#!/usr/bin/env bats

load _test_base

FIRST_FILE="file_to_hide1"
SECOND_FILE="file_to_hide2"

# There was a bug with `sed` an slashes:
# see https://github.com/sobolevn/git-secret/issues/23
FOLDER="somedir"
FILE_IN_FOLDER="${FOLDER}/file_to_hide3"


function setup {
  install_fixture_full_key "$TEST_DEFAULT_USER"

  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FIRST_FILE" "somecontent"
  set_state_secret_add "$SECOND_FILE" "somecontent2"
}


function teardown {
  uninstall_fixture_full_key "$TEST_DEFAULT_USER"
  unset_current_state
  rm -f "$FIRST_FILE" "$SECOND_FILE"
}


@test "run 'remove' normally" {
  git secret hide

  run git secret remove "$SECOND_FILE"
  [ "$status" -eq 0 ]

  local mapping_contains=$(grep "$SECOND_FILE" "$SECRETS_DIR_PATHS_MAPPING"; echo $?)
  [ "$mapping_contains" -eq 1 ]

  local first_enctypted_file=$(_get_encrypted_filename $FIRST_FILE)
  local second_enctypted_file=$(_get_encrypted_filename $SECOND_FILE)

  [ -f "$first_enctypted_file" ]
  [ -f "$second_enctypted_file" ]
}


@test "run 'remove' with slashes in filename" {
  mkdir -p "$FOLDER"
  set_state_secret_add "$FILE_IN_FOLDER" "somecontent3"
  git secret hide

  run git secret remove "$FILE_IN_FOLDER"
  [ "$status" -eq 0 ]

  local mapping_contains=$(grep "$FILE_IN_FOLDER" "$SECRETS_DIR_PATHS_MAPPING"; echo $?)
  [ "$mapping_contains" -eq 1 ]

  local enctypted_file=$(_get_encrypted_filename $FILE_IN_FOLDER)
  [ -f "$enctypted_file" ]
}


@test "run 'remove -c'" {
  git secret hide

  run git secret remove -c "$SECOND_FILE"
  echo "$output"
  [ "$status" -eq 0 ]

  local mapping_contains=$(grep "$SECOND_FILE" "$SECRETS_DIR_PATHS_MAPPING"; echo $?)
  [ "$mapping_contains" -eq 1 ]

  local first_enctypted_file=$(_get_encrypted_filename $FIRST_FILE)
  local second_enctypted_file=$(_get_encrypted_filename $SECOND_FILE)

  [ -f "$first_enctypted_file" ]
  [ ! -f "$second_enctypted_file" ]
}

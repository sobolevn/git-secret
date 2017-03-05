#!/usr/bin/env bats

load _test_base

FIRST_FILE="file_to_hide1"
SECOND_FILE="file_to_hide2"

FOLDER="somedir"
FILE_IN_FOLDER="${FOLDER}/file_to_hide3"


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FIRST_FILE" "somecontent"
  set_state_secret_add "$SECOND_FILE" "somecontent2"
  set_state_secret_hide
}


function teardown {
  rm "$FIRST_FILE" "$SECOND_FILE"
  rm -r "$FOLDER"

  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


function _has_line {
  local line="$1"

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local result=$(grep -q "$line" "$path_mappings"; echo $?)
  echo "$result"
}


@test "run 'remove' normally" {
  run git secret remove "$SECOND_FILE"
  [ "$status" -eq 0 ]

  # Mapping should not contain the second file:
  local mapping_contains=$(_has_line "$SECOND_FILE")
  [ "$mapping_contains" -eq 1 ]

  # But the first file must not change:
  local other_files=$(_has_line "$FIRST_FILE")
  [ "$other_files" -eq 0 ]

  # Both files should be present:
  local first_enctypted_file=$(_get_encrypted_filename $FIRST_FILE)
  local second_enctypted_file=$(_get_encrypted_filename $SECOND_FILE)

  [ -f "$first_enctypted_file" ]
  [ -f "$second_enctypted_file" ]
}


@test "run 'remove' with multiple arguments" {
  run git secret remove "$FIRST_FILE" "$SECOND_FILE"
  [ "$status" -eq 0 ]

  local first_line=$(_has_line "$FIRST_FILE")
  [ "$first_line" -eq 1 ]

  local second_line=$(_has_line "$SECOND_FILE")
  [ "$second_line" -eq 1 ]

  # Both files should be present:
  local first_enctypted_file=$(_get_encrypted_filename $FIRST_FILE)
  local second_enctypted_file=$(_get_encrypted_filename $SECOND_FILE)

  [ -f "$first_enctypted_file" ]
  [ -f "$second_enctypted_file" ]
}


@test "run 'remove' with slashes in filename" {
  # There was a bug with `sed` an slashes:
  # see https://github.com/sobolevn/git-secret/issues/23

  # Prepartions:
  mkdir -p "$FOLDER"
  set_state_secret_add "$FILE_IN_FOLDER" "somecontent3"
  set_state_secret_hide # runing hide again to hide new data

  # Now it should remove filename with slashes from the mapping:
  run git secret remove "$FILE_IN_FOLDER"
  [ "$status" -eq 0 ]

  local mapping_contains=$(_has_line "$FILE_IN_FOLDER")
  [ "$mapping_contains" -eq 1 ]

  local enctypted_file=$(_get_encrypted_filename $FILE_IN_FOLDER)
  [ -f "$enctypted_file" ]
}


@test "run 'remove' with '-c'" {
  git secret hide

  run git secret remove -c "$SECOND_FILE"
  echo "$output"
  [ "$status" -eq 0 ]

  local mapping_contains=$(_has_line "$SECOND_FILE")
  [ "$mapping_contains" -eq 1 ]

  local first_enctypted_file=$(_get_encrypted_filename $FIRST_FILE)
  local second_enctypted_file=$(_get_encrypted_filename $SECOND_FILE)

  [ -f "$first_enctypted_file" ]
  [ ! -f "$second_enctypted_file" ]
}

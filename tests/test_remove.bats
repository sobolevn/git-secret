#!/usr/bin/env bats

load _test_base

FIRST_FILE="$TEST_DEFAULT_FILENAME"
SECOND_FILE="$TEST_SECOND_FILENAME"


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

  # Test output:
  [[ "$output" == *"removed from index."* ]]
  [[ "$output" == *"ensure that files: [$SECOND_FILE] are now not ignored."* ]]

  # Mapping should not contain the second file:
  local mapping_contains=$(_has_line "$SECOND_FILE")
  [ "$mapping_contains" -eq 1 ]

  # But the first file must not change:
  local other_files=$(_has_line "$FIRST_FILE")
  [ "$other_files" -eq 0 ]

  # Both files should be present:
  local first_encrypted_file=$(_get_encrypted_filename "$FIRST_FILE")
  local second_encrypted_file=$(_get_encrypted_filename "$SECOND_FILE")

  [ -f "$first_encrypted_file" ]
  [ -f "$second_encrypted_file" ]
}


@test "run 'remove' with multiple arguments" {
  run git secret remove "$FIRST_FILE" "$SECOND_FILE"
  [ "$status" -eq 0 ]

  local first_line=$(_has_line "$FIRST_FILE")
  [ "$first_line" -eq 1 ]

  local second_line=$(_has_line "$SECOND_FILE")
  [ "$second_line" -eq 1 ]

  # Both files should be present:
  local first_encrypted_file=$(_get_encrypted_filename "$FIRST_FILE")
  local second_encrypted_file=$(_get_encrypted_filename "$SECOND_FILE")

  [ -f "$first_encrypted_file" ]
  [ -f "$second_encrypted_file" ]
}


@test "run 'remove' with slashes in filename" {
  # There was a bug with `sed` an slashes:
  # see https://github.com/sobolevn/git-secret/issues/23

  # Preparations:
  local folder="somedir"
  local file_in_folder="$folder/$TEST_THIRD_FILENAME"

  mkdir -p "$folder"
  set_state_secret_add "$file_in_folder" "somecontent3"
  set_state_secret_hide # running hide again to hide new data

  # Now it should remove filename with slashes from the mapping:
  run git secret remove "$file_in_folder"
  [ "$status" -eq 0 ]

  local mapping_contains=$(_has_line "$file_in_folder")
  [ "$mapping_contains" -eq 1 ]

  local encrypted_file=$(_get_encrypted_filename "$file_in_folder")
  [ -f "$encrypted_file" ]

  # Cleaning up:
  rm -r "$folder"
}


@test "run 'remove' with '-c'" {
  set_state_secret_hide

  run git secret remove -c "$SECOND_FILE"
  [ "$status" -eq 0 ]

  local mapping_contains=$(_has_line "$SECOND_FILE")
  [ "$mapping_contains" -eq 1 ]

  local first_encrypted_file=$(_get_encrypted_filename "$FIRST_FILE")
  local second_encrypted_file=$(_get_encrypted_filename "$SECOND_FILE")
  echo "$output"
  echo "$first_encrypted_file and $second_encrypted_file"

  [ -f "$first_encrypted_file" ]
  [ ! -f "$second_encrypted_file" ]
}

@test "run 'remove' with bad arg" {
  set_state_secret_hide
  run git secret remove -Z "$SECOND_FILE"
  [ "$status" -ne 0 ]
}


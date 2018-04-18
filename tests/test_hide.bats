#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="file_to_hide"
FILE_CONTENTS="hidden content юникод"


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
}


function teardown {
  rm "$FILE_TO_HIDE"

  uninstall_fixture_key $TEST_DEFAULT_USER
  unset_current_state
}


@test "run 'hide' normally" {
  run git secret hide

  # Command must execute normally:
  [ "$status" -eq 0 ]
  [ "$output" = "done. all 1 files are hidden." ]

  # New files should be crated:
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  [ -f "$encrypted_file" ]
}

@test "run 'hide' with missing file" {
  # Preparations:
  local second_file="second_file.txt"
  local second_content="some content"
  set_state_secret_add "$second_file" "$second_content"

  # now remove the second file to cause failure
  rm -f "$second_file"

  # Now it should return an error because one file can't be found
  run git secret hide
  [ "$status" -ne 0 ]
  [ "$output" != "done. all 2 files are hidden." ]
}


@test "run 'hide' with multiple files" {
  # Preparations:
  local second_file="second_file.txt"
  local second_content="some content"
  set_state_secret_add "$second_file" "$second_content"

  # Now it should hide 2 files:
  run git secret hide
  [ "$status" -eq 0 ]
  [ "$output" = "done. all 2 files are hidden." ]

  # Cleaning up:
  rm "$second_file"
}


@test "run 'hide' with '-m'" {
  run git secret hide -m

  # Command must execute normally:
  [ "$status" -eq 0 ]
  # git secret hide -m, use temp file so cleaning should take place
  [[ "${#lines[@]}" -eq 2 ]]
  [ "${lines[0]}" = "done. all 1 files are hidden." ]
  [ "${lines[1]}" = "cleaning up..." ]

  # New files should be crated:
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  [ -f "$encrypted_file" ]
}


@test "run 'hide' with '-m' twice" {
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)
  run git secret hide -m


  # Command must execute normally:
  [ "$status" -eq 0 ]
  # git secret hide -m, uses a temp file so cleaning should take place
  [[ "${#lines[@]}" -eq 2 ]]
  [ "${lines[0]}" = "done. all 1 files are hidden." ]
  [ "${lines[1]}" = "cleaning up..." ]
  # back path mappings
  cp "${path_mappings}" "${path_mappings}.bak"
  # run hide again
  run git secret hide -m
  # compare
  [ "$status" -eq 0 ]
  [[ "${#lines[@]}" -eq 1 ]]
  [ "$output" = "done. all 1 files are hidden." ]
  # no changes should occur to path_mappings files
  cmp -s "${path_mappings}" "${path_mappings}.bak"

  # New files should be crated:
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  [ -f "$encrypted_file" ]
}


@test "run 'hide' with '-c' and '-v'" {
  # Preparations:
  local encrypted_filename=$(_get_encrypted_filename "$FILE_TO_HIDE")
  set_state_secret_hide # so it would be data to clean

  run git secret hide -v -c
  [ "$status" -eq 0 ]

  # File should be still there (it is not deletion):
  [ -f "$FILE_TO_HIDE" ]

  # Output should be verbose:
  [[ "$output" == *"cleaning"* ]]
  [[ "$output" == *"$encrypted_filename"* ]]
}


@test "run 'hide' with '-d'" {
  run git secret hide -d
  [ "$status" -eq 0 ]

  ls && pwd

  # File must be removed:
  [ ! -f "$FILE_TO_HIDE" ]
}


@test "run 'hide' with '-d' and '-v'" {
  run git secret hide -v -d
  [ "$status" -eq 0 ]

  ls && pwd

  # File must be removed:
  [ ! -f "$FILE_TO_HIDE" ]

  # It should be verbose:
  [[ "$output" == *"removing unencrypted files"* ]]
  [[ "$output" == *"$FILE_TO_HIDE"* ]]
}


@test "run 'hide' with '-d' and '-v' and files in subdirectories" {
  # Preparations:
  local root_dir='test_sub_dir'
  mkdir -p "$root_dir"
  local second_file="$root_dir/second_file.txt"
  local second_content="some content"
  set_state_secret_add "$second_file" "$second_content"

  # Verify that the second file is there:
  [ -f "$second_file" ]

  # Now it should hide 2 files:
  run git secret hide -v -d
  [ "$status" -eq 0 ]

  # File must be removed:
  [ ! -f "$FILE_TO_HIDE" ]
  [ ! -f "$second_file" ]

  # It should be verbose:
  [[ "$output" == *"removing unencrypted files"* ]]
  [[ "$output" == *"$FILE_TO_HIDE"* ]]
  [[ "$output" == *"$second_file"* ]]
}


@test "run 'hide' with multiple users" {
  install_fixture_key "$TEST_SECOND_USER"
  set_state_secret_tell "$TEST_SECOND_USER"

  run git secret hide
  [ "$status" -eq 0 ]
  [ "$output" = "done. all 1 files are hidden." ]
}

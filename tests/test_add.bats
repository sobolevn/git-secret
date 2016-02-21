#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
}


function teardown {
  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


@test "run 'add' for unignored file" {
  local TEST_FILE='test_file'
  touch "$TEST_FILE"
  echo "content" > "$TEST_FILE"

  run git secret add "$TEST_FILE"
  rm -f "$TEST_FILE"

  [ "$status" -eq 1 ]
}


@test "run 'add' normally" {
  local filename="local_file"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  run git secret add "$filename"
  rm -f "$filename" ".gitignore"

  [ "$status" -eq 0 ]

  local files_list=$(cat "$SECRETS_DIR_PATHS_MAPPING")
  [ "$files_list" = "$filename" ]
}


@test "run 'add' twice for one file" {
  local filename="local_file"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  run git secret add "$filename"
  run git secret add "$filename"
  rm -f "$filename" ".gitignore"

  [ "$status" -eq 0 ]
  [ "$output" = "1 items added." ]

  local files_list=`cat "$SECRETS_DIR_PATHS_MAPPING"`
  [ "$files_list" = "$filename" ]
}


@test "run 'add' for multiple files" {
  local filename1="local_file1"
  echo "content1" > "$filename1"
  echo "$filename1" > ".gitignore"

  local filename2="local_file2"
  echo "content2" > "$filename2"
  echo "$filename2" >> ".gitignore"

  run git secret add "$filename1" "$filename2"
  rm -f "$filename1" "$filename2" ".gitignore"

  [ "$status" -eq 0 ]
  [ "$output" = "2 items added." ]
}

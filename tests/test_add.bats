#!/usr/bin/env bats

load _test_base


function setup {
  install_fixture_key "$TEST_DEFAULT_USER"

  set_state_initial
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
  [ "$status" -eq 1 ]

  rm -f "$TEST_FILE"
}


@test "run 'add' for unignored file with '-i'" {
  local TEST_FILE='test_file.auto_ignore'
  touch "$TEST_FILE"
  echo "content" > "$TEST_FILE"

  run git secret add -i "$TEST_FILE"
  [ "$status" -eq 0 ]

  run _file_has_line "$TEST_FILE" ".gitignore"
  [ "$status" -eq 0 ]

  rm -f "$TEST_FILE"
}


@test "run 'add' normally" {
  local filename="local_file"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  run git secret add "$filename"
  [ "$status" -eq 0 ]

  rm -f "$filename" ".gitignore"

  local files_list=$(cat "$SECRETS_DIR_PATHS_MAPPING")
  [ "$files_list" = "$filename" ]
}


@test "run 'add' for file in subdirectory" {
  local TEST_FILE='test_file'
  local TEST_DIR='test_dir'

  mkdir -p "$TEST_DIR"
  touch "$TEST_DIR/$TEST_FILE"
  echo "content" > "$TEST_DIR/$TEST_FILE"
  echo "$TEST_DIR/$TEST_FILE" > ".gitignore"

  run git secret add "$TEST_DIR/$TEST_FILE"
  [ "$status" -eq 0 ]
  [[ "$output" == *"1 items added."* ]]

  rm -rf "$TEST_DIR"
}


@test "run 'add' twice for one file" {
  local filename="local_file"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  run git secret add "$filename"
  run git secret add "$filename"
  [ "$status" -eq 0 ]
  [ "$output" = "1 items added." ]

  rm -f "$filename" ".gitignore"

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
  [ "$status" -eq 0 ]
  [ "$output" = "2 items added." ]

  rm -f "$filename1" "$filename2" ".gitignore"
}

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


@test "run 'add' normally" {
  # Preparations:
  local filename="$TEST_DEFAULT_FILENAME"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  run git secret add "$filename"
  [ "$status" -eq 0 ]

  # Ensuring that path mappings was set correctly:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list=$(cat "$path_mappings")
  [ "$files_list" = "$filename" ]

  # Cleaning up:
  rm "$filename" ".gitignore"
}


@test "run 'add' for unignored file" {
  local test_file="$TEST_DEFAULT_FILENAME"
  touch "$test_file"
  echo "content" > "$test_file"

  run git secret add "$test_file"
  [ "$status" -eq 1 ]

  rm "$test_file"
}


@test "run 'add' for unignored file with '-i'" {
  local test_file='test_file.auto_ignore'   # TODO - parameterize filename
  touch "$test_file"
  echo "content" > "$test_file"

  run git secret add -i "$test_file"
  [ "$status" -eq 0 ]

  run _file_has_line "$test_file" ".gitignore"
  [ "$status" -eq 0 ]

  rm "$test_file"
}


@test "run 'add' for un-ignored file with '-i' in subfolder" {
  # This test covers this issue:
  # https://github.com/sobolevn/git-secret/issues/85 task 1

  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    # See #334 for more about this
    skip "this test is skipped while 'git commit'"
  fi

  # Preparations:
  local test_dir='test_dir'
  local nested_dir="$test_dir/adding"
  local current_dir=$(pwd)

  mkdir -p "$nested_dir"
  cd "$nested_dir"

  local test_file='test_file.auto_ignore'
  touch "$test_file"
  echo "content" > "$test_file"

  # Test commands:
  run git secret add -i "$test_file"
  [ "$status" -eq 0 ]

  run _file_has_line "$test_file" "../.gitignore"
  [ "$status" -eq 0 ]

  # .gitignore was not created:
  [[ ! -f ".gitignore" ]]

  # Cleaning up:
  cd "$current_dir"
  rm -r "$test_dir"
}


@test "run 'add' for relative path" {
  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    skip "this test is skipped while 'git commit'. See #334"
  fi

  # Preparations:
  local root='test_dir'
  local node="$root/node"
  local sibling="$root/sibling"
  local test_file="$node/$TEST_DEFAULT_FILENAME"
  local current_dir=$(pwd)

  mkdir -p "$node"
  mkdir -p "$sibling"

  echo "content" > "$test_file"
  echo "$test_file" > ".gitignore"

  cd "$sibling"

  # Testing:
  run git secret add "../node/$TEST_DEFAULT_FILENAME"
  [ "$status" -eq 0 ]
  [[ "$output" == *"1 item(s) added."* ]]

  # Testing mappings content:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list=$(cat "$path_mappings")
  [ "$files_list" = "$test_file" ]

  # Cleaning up:
  cd "$current_dir"
  rm -r "$root"
}


@test "run 'add' for file in subfolder" {
  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    # See #334 for more about this
    skip "this test is skipped while 'git commit'"
  fi

  # Preparations:
  local test_file="$TEST_DEFAULT_FILENAME"
  local test_dir='test_dir'

  mkdir -p "$test_dir"
  touch "$test_dir/$test_file"
  echo "content" > "$test_dir/$test_file"
  echo "$test_dir/$test_file" > ".gitignore"

  # Testing:
  run git secret add "$test_dir/$test_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"1 item(s) added."* ]]

  # Cleaning up:
  rm -r "$test_dir"
}


@test "run 'add' twice for one file" {
  # Preparations:
  local filename="$TEST_DEFAULT_FILENAME"
  echo "content" > "$filename"
  echo "$filename" > ".gitignore"

  # Testing:
  run git secret add "$filename"
  run git secret add "$filename"
  [ "$status" -eq 0 ]
  [ "$output" = "1 item(s) added." ]

  # Ensuring that path mappings was set correctly:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list=$(cat "$path_mappings")
  [ "$files_list" = "$filename" ]

  # Cleaning up:
  rm "$filename" ".gitignore"
}


@test "run 'add' for multiple files" {
  # Preparations:
  local filename1="$TEST_DEFAULT_FILENAME"
  echo "content1" > "$filename1"
  echo "$filename1" > ".gitignore"

  local filename2="$TEST_SECOND_FILENAME"
  echo "content2" > "$filename2"
  echo "$filename2" >> ".gitignore"

  # Testing:
  run git secret add "$filename1" "$filename2"
  [ "$status" -eq 0 ]
  [ "$output" = "2 item(s) added." ]

  # Cleaning up:
  rm "$filename1" "$filename2" ".gitignore"
}

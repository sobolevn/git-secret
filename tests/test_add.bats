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
  #echo "$filename" > ".gitignore"  # this is performed by 'add' now

  run git secret add "$filename"
  [ "$status" -eq 0 ]

  # Ensuring that path mappings was set correctly:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list
  files_list=$(cat "$path_mappings")
  [ "$files_list" = "$filename" ]

  # Cleaning up:
  rm "$filename" ".gitignore"
}


@test "run 'add' with bad arg" {
  local test_file="$TEST_DEFAULT_FILENAME"
  touch "$test_file"
  echo "content" > "$test_file"

  run git secret add -Z "$test_file"
  [ "$status" -ne 0 ]

  rm "$test_file"
}


@test "run 'add' for file ignored by default" {
  local test_file="$TEST_DEFAULT_FILENAME"
  touch "$test_file"
  echo "content" > "$test_file"

  run git secret add "$test_file"
  [ "$status" -eq 0 ]

  rm "$test_file"
}


@test "run 'add' for file ignored with '-i' and '.gitignore' contents" {
  local test_file="$TEST_DEFAULT_FILENAME"
  touch "$test_file"
  echo "content" > "$test_file"

  local quoted_name
  quoted_name=$(printf '%q' "$test_file")

  # add -i is now a no-op (See #225) so this tests that -i does nothing.
  run git secret add -i "$test_file"
  [ "$status" -eq 0 ]

  run file_has_line "$quoted_name" ".gitignore"
  [ "$output" = '0' ]

  local expected=.gitsec/keys/random_seed$'\n'\!\*.sec$'\n'$quoted_name
  echo "$expected" > '.expected'

  [ "$(cmp '.expected' '.gitignore'; echo $?)" -eq 0 ]

  rm "$test_file" '.expected'
}


@test "run 'add' for file ignored by default and with '-i' in subfolder" {
  # This test covers this issue:
  # https://github.com/sobolevn/git-secret/issues/85 task 1

  if [[ "$BATS_RUNNING_FROM_GIT" -eq 1 ]]; then
    # See #334 for more about this
    skip "this test is skipped while 'git commit'"
  fi

  # Preparations:
  local test_dir='test_dir'
  local nested_dir="$test_dir/adding"
  local current_dir="$PWD"

  mkdir -p "$nested_dir"
  cd "$nested_dir"

  local test_file='test_file.auto_ignore'
  touch "$test_file"
  echo "content" > "$test_file"

  # Test commands:
  run git secret add -i "$test_file"
  [ "$status" -eq 0 ]

  [[ -f "$current_dir/.gitignore" ]]
  run file_has_line "$test_file" "$current_dir/.gitignore"
  [ "$output" = '0' ]

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
  local current_dir="$PWD"

  mkdir -p "$node"
  mkdir -p "$sibling"

  echo "content" > "$test_file"
  #echo "$test_file" > ".gitignore"  # this is performed by 'add' now

  cd "$sibling"

  # Testing:
  run git secret add "../node/$TEST_DEFAULT_FILENAME"
  [ "$status" -eq 0 ]
  [[ "$output" == *"git-secret: 1 item(s) added."* ]]

  # Testing mappings content:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list
  files_list=$(cat "$path_mappings")
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
  #echo "$test_dir/$test_file" > ".gitignore"    # this is performed by 'add' now

  # Testing:
  run git secret add "$test_dir/$test_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"git-secret: 1 item(s) added."* ]]

  # Cleaning up:
  rm -r "$test_dir"
}


@test "run 'add' twice for one file" {
  # Preparations:
  local filename="$TEST_DEFAULT_FILENAME"
  echo "content" > "$filename"
  #echo "$filename" > ".gitignore"   # this is performed by 'add' now

  # Testing:
  run git secret add "$filename"
  run git secret add "$filename"
  [ "$status" -eq 0 ]
  [ "$output" = "git-secret: 0 item(s) added." ]

  # Ensuring that path mappings was set correctly:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list
  files_list=$(cat "$path_mappings")
  [ "$files_list" = "$filename" ]

  # Cleaning up:
  rm "$filename" ".gitignore"
}


@test "run 'add' for multiple files" {
  # Preparations:
  local filename1="$TEST_DEFAULT_FILENAME"
  echo "content1" > "$filename1"
  #echo "$filename1" > ".gitignore"  # this is performed by 'add' now

  local filename2="$TEST_SECOND_FILENAME"
  echo "content2" > "$filename2"
  #echo "$filename2" >> ".gitignore" # this is performed by 'add' now
  
  # ADD TEST for .gitignore contents here
  # This fails now because of #789

  # Testing:
  run git secret add "$filename1" "$filename2"

  # debugging code
  echo "$output" | sed 's/^/# DEBUG: output from git secret add: /' >&3  # fd 3 for bats
  cat .gitignore | sed 's/^/# DEBUG: .gitignore: /' >&3  # show .gitignore through bats

  [ "$status" -eq 0 ]
  [[ "$output" = *"git-secret: 2 item(s) added."* ]]   # there may be additional lines too

  # Cleaning up:
  rm "$filename1" "$filename2" ".gitignore"
}

@test "run 'add -v' for multiple files" {
  # Preparations:
  local filename1="$TEST_DEFAULT_FILENAME"
  echo "content1" > "$filename1"
  #echo "$filename1" > ".gitignore"  # this is performed by 'add' now

  local filename2="$TEST_SECOND_FILENAME"
  echo "content2" > "$filename2"
  #echo "$filename2" >> ".gitignore" # this is performed by 'add' now

  # Testing:
  run git secret add -v "$filename1" "$filename2"

  [ "$status" -eq 0 ]
  [[ "$output" == *"git-secret: adding file: ${TEST_DEFAULT_FILENAME}"* ]]
  [[ "$output" == *"git-secret: adding file: ${TEST_SECOND_FILENAME}"* ]]
  [[ "$output" == *"git-secret: 2 item(s) added."* ]]

  # Cleaning up:
  rm "$filename1" "$filename2" ".gitignore"
}

@test "run 'add' for file with special chars" {
  # Preparations:
  local filename="$TEST_FOURTH_FILENAME"
  echo "content" > "$filename"
  #echo "$filename" > ".gitignore"   # this is performed by 'add' now

  run git secret add "$filename"
  [ "$status" -eq 0 ]

  # Ensuring that path mappings was set correctly:
  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local files_list
  files_list=$(cat "$path_mappings")
  [ "$files_list" = "$filename" ]

  # Ensuring the file is correctly git-ignored
  run git check-ignore "$filename"
  [ "$status" -eq 0 ]

  # Cleaning up:
  rm "$filename" ".gitignore"
}

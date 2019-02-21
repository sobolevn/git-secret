#!/usr/bin/env bats

load _test_base

FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
SECOND_FILE_TO_HIDE="$TEST_SECOND_FILENAME"
THIRD_FILE_TO_HIDE="$TEST_THIRD_FILENAME"
FILE_NON_EXISTENT="NO-SUCH-FILE"
FILE_CONTENTS="hidden content юникод"

FINGERPRINT=""


function setup {
  FINGERPRINT=$(install_fixture_full_key "$TEST_DEFAULT_USER")

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_DEFAULT_USER"
  set_state_secret_add "$FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_add "$SECOND_FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_hide
}


function teardown {
  rm "$FILE_TO_HIDE" "$SECOND_FILE_TO_HIDE"

  uninstall_fixture_full_key "$TEST_DEFAULT_USER" "$FINGERPRINT"
  unset_current_state
}

@test "run 'changes' on one file with no file changed" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE"

  [ "$status" -eq 0 ]

  local num_lines=$(echo "$output" | wc -l)
  [[ "$num_lines" -eq 1 ]]
}


@test "run 'changes' with one file changed" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local new_content="new content"
  echo "$new_content" >> "$FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE"
  [ "$status" -eq 0 ]

  # Testing that output has both filename and changes:
  local fullpath=$(_append_root_path "$FILE_TO_HIDE")
  [[ "$output" == *"changes in $fullpath"* ]]
  [[ "$output" == *"hidden content юникод"* ]]
  [[ "$output" == *"+$new_content"* ]]

  local num_lines=$(echo "$output" | wc -l)
  [[ "$num_lines" -eq 6 ]]

}

@test "run 'changes' with source file missing" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  rm "$FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE"
  [ "$status" -ne 0 ]
}

@test "run 'changes' with hidden file missing" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local encrypted_file=$(_get_encrypted_filename "$FILE_TO_HIDE")
  rm "$encrypted_file"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE"
  [ "$status" -ne 0 ]
}


@test "run 'changes' with one file changed (with deletions)" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local new_content="replace"
  echo "$new_content" > "$FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_TO_HIDE"
  [ "$status" -eq 0 ]

  # Testing that output has both filename and changes:
  local fullpath=$(_append_root_path "$FILE_TO_HIDE")
  [[ "$output" == *"changes in $fullpath"* ]]
  [[ "$output" == *"-$FILE_CONTENTS"* ]]
  [[ "$output" == *"+$new_content"* ]]
}


@test "run 'changes' on two files with no file changed" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password"


  [ "$status" -eq 0 ]

  local num_lines=$(echo "$output" | wc -l)
  [[ "$num_lines" -eq 2 ]]   
}


@test "run 'changes' with multiple files changed" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local new_content="new content"
  local second_new_content="something different"
  echo "$new_content" >> "$FILE_TO_HIDE"
  echo "$second_new_content" >> "$SECOND_FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password"
  [ "$status" -eq 0 ]

  # Testing that output has both filename and changes:
  local fullpath=$(_append_root_path "$FILE_TO_HIDE")

  [[ "$output" == *"changes in $fullpath"* ]]
  [[ "$output" == *"+$new_content"* ]]

  local second_path=$(_append_root_path "$SECOND_FILE_TO_HIDE")
  [[ "$output" == *"changes in $second_path"* ]]
  [[ "$output" == *"+$second_new_content"* ]]
}


@test "run 'changes' with multiple selected files changed" {
  local password=$(test_user_password "$TEST_DEFAULT_USER")
  local new_content="new content"
  local second_new_content="something different"
  echo "$new_content" >> "$FILE_TO_HIDE"
  echo "$second_new_content" >> "$SECOND_FILE_TO_HIDE"

  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" \
    "$FILE_TO_HIDE" "$SECOND_FILE_TO_HIDE"

  [ "$status" -eq 0 ]

  # Testing that output has both filename and changes:
  local fullpath=$(_append_root_path "$FILE_TO_HIDE")
  [[ "$output" == *"changes in $fullpath"* ]]
  [[ "$output" == *"+$new_content"* ]]

  local second_path=$(_append_root_path "$SECOND_FILE_TO_HIDE")
  [[ "$output" == *"changes in $second_path"* ]]
  [[ "$output" == *"+$second_new_content"* ]]
}

@test "run 'changes' on file that does not exist" {
  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$FILE_NON_EXISTENT"
  [ "$status" -ne 0 ]
}

@test "run 'changes' on one file without newlines" {
  set_state_secret_add_without_newline "$THIRD_FILE_TO_HIDE" "$FILE_CONTENTS"
  set_state_secret_hide

  local password=$(test_user_password "$TEST_DEFAULT_USER")
  run git secret changes -d "$TEST_GPG_HOMEDIR" -p "$password" "$THIRD_FILE_TO_HIDE"
  [ "$status" -eq 0 ]

  local num_lines=$(echo "$output" | wc -l)
  [[ "$num_lines" -eq 1 ]]
}

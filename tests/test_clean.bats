#!/usr/bin/env bats

load _test_base

FIRST_FILE="$TEST_DEFAULT_FILENAME"
SECOND_FILE="$TEST_SECOND_FILENAME"

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
  # This also needs to be cleaned:
  rm "$FIRST_FILE" "$SECOND_FILE"
  rm -r "$FOLDER"

  uninstall_fixture_key "$TEST_DEFAULT_USER"
  unset_current_state
}


function _secret_files_exists {
  local result=$(find . -type f -name "*.$SECRETS_EXTENSION" \
    -print0 2>/dev/null | grep -q .; echo "$?")
  echo "$result"
}


@test "run 'clean' normally" {
  run git secret clean
  [ "$status" -eq 0 ]

  # There must be no .secret files:
  local exists=$(_secret_files_exists)
  [ "$exists" -ne 0 ]
}


@test "run 'clean' with '-v'" {
  run git secret clean -v
  [ "$status" -eq 0 ]

  # There must be no .secret files:
  local exists=$(_secret_files_exists)
  [ "$exists" -ne 0 ]

  local first_filename=$(_get_encrypted_filename "$FIRST_FILE")
  local second_filename=$(_get_encrypted_filename "$SECOND_FILE")

  # Output must be verbose:
  [[ "$output" == *"cleaning"* ]]
  [[ "$output" == *"$first_filename"* ]]
  [[ "$output" == *"$second_filename"* ]]
}

#!/usr/bin/env bats

# These tests using TEST_NONAME_USER, which has a email but no username.
# This was originally based on test_remove.bats

load _test_base

FIRST_FILE="$TEST_DEFAULT_FILENAME"
SECOND_FILE="$TEST_SECOND_FILENAME"

function setup {
  install_fixture_key "$TEST_NONAME_USER"

  set_state_initial
  set_state_git
  set_state_secret_init
  set_state_secret_tell "$TEST_NONAME_USER"
  set_state_secret_add "$FIRST_FILE" "somecontent"
  set_state_secret_add "$SECOND_FILE" "somecontent2"
  set_state_secret_hide
}


function teardown {
  rm "$FIRST_FILE" "$SECOND_FILE"

  uninstall_fixture_key "$TEST_NONAME_USER"
  unset_current_state
}


function _has_line {
  local line="$1"

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)
  echo "$(grep -q "$line" "$path_mappings"; echo $?)"
}


@test "run 'remove' for nameless user normally" {
  run git secret remove "$SECOND_FILE"
  [ "$status" -eq 0 ]

  # Test output:
  [[ "$output" == *"removed from index."* ]]
  [[ "$output" == *"ensure that files: [$SECOND_FILE] are now not ignored."* ]]

  # Mapping should not contain the second file:
  [ "$(_has_line "$SECOND_FILE")" -eq 1 ]

  # But the first file must not change:
  [ "$(_has_line "$FIRST_FILE")" -eq 0 ]

  # Both files should be present:
  [ -f "$(_get_encrypted_filename "$FIRST_FILE")" ]
  [ -f "$(_get_encrypted_filename "$SECOND_FILE")" ]
}


#!/usr/bin/env bats

load _test_base


# minimal git setup
#function setup {
#  set_state_initial
#  set_state_git
#}
#function teardown {
#  unset_current_state
#}


# complete git secret setup
FILE_TO_HIDE="$TEST_DEFAULT_FILENAME"
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

@test "gnupg diagnostics" {
  run git secret hide

  echo "# which gpg ------" >&3
  which gpg             | xargs ls -l | sed "s/^/# '$BATS_TEST_DESCRIPTION' which gpg: /" >&3
  echo "# gpg --version ------" >&3
  gpg --version                       | sed "s/^/# '$BATS_TEST_DESCRIPTION' gpg --version: /" >&3
  echo "# ------" >&3

  echo "# which gpg2 ------" >&3
  which gpg2            | xargs ls -l | sed "s/^/# '$BATS_TEST_DESCRIPTION' which gpg2: /" >&3
  echo "# gpg2 --version ------" >&3
  gpg2 --version                      | sed "s/^/# '$BATS_TEST_DESCRIPTION' gpg2 --version: /" >&3
  echo "# ------" >&3

  echo "# contents of ~/.gnupg ------" >&3
  find ~/.gnupg -type f               | sed "s/^/# '$BATS_TEST_DESCRIPTION' HOME\/.gnupg: /" >&3
  echo "# ------" >&3
 
  echo "# contents of TEST_GPG_HOMEDIR ($TEST_GPG_HOMEDIR) ------" >&3
  ls $TEST_GPG_HOMEDIR                          | sed "s:^:# '$BATS_TEST_DESCRIPTION' '$TEST_GPG_HOMEDIR'\: :" >&3
  echo "# ------" >&3
 
  [ 1 ]
 
}

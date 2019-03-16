#!/usr/bin/env bats

#load _test_base


#function setup {
#  set_state_initial
#  set_state_git
#}
#function teardown {
#  unset_current_state
#}


@test "gnupg diagnostics" {
  which gpg             | xargs ls -l | sed "s/^/# '$BATS_TEST_DESCRIPTION' which gpg: /" >&3
  echo "# ------" >&3
  gpg --version                       | sed "s/^/# '$BATS_TEST_DESCRIPTION' gpg --version: /" >&3
  echo "# ------" >&3

  which gpg2            | xargs ls -l | sed "s/^/# '$BATS_TEST_DESCRIPTION' which gpg2: /" >&3
  echo "# ------" >&3
  gpg2 --version                      | sed "s/^/# '$BATS_TEST_DESCRIPTION' gpg2 --version: /" >&3
  echo "# ------" >&3

  find ~/.gnupg -type f               | sed "s/^/# '$BATS_TEST_DESCRIPTION' HOME\/.gnupg: /" >&3
  echo "# ------" >&3
 
  [ 1 ]
 
}

#!/usr/bin/env bats

load _test_base



@test "test for perl binary" {

  perl -v           # show output
  command -v perl # show output

  #run command -v perl
  #[ "$status" -eq 0 ]

  local perl_test_file="perl-v-output"

  perl -v > "$perl_test_file"       # output of perl -v
  bats_diag_file "$perl_test_file"  # show the contents as diagnostic output
}


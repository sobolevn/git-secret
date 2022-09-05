#!/usr/bin/env bats

load _test_base


function setup {
}


function teardown {
}


@test "run 'add' normally" {

  run which perl
  [ "$status" -ne 0 ]

  local perl_test_file="perl-v-output"

  perl -v > "$perl_test_file"
  
}


emulate_bats_env() {
  export BATS_CWD="$PWD"
  export BATS_TEST_FILTER=
  export BATS_ROOT_PID=$$
  export BATS_RUN_TMPDIR
  BATS_RUN_TMPDIR=$(mktemp -d "${BATS_RUN_TMPDIR}/emulated-tmpdir-${BATS_ROOT_PID}-XXXXXX")
}

fixtures() {
  FIXTURE_ROOT="$BATS_TEST_DIRNAME/fixtures/$1"
  # shellcheck disable=SC2034
  RELATIVE_FIXTURE_ROOT="${FIXTURE_ROOT#$BATS_CWD/}"
}

filter_control_sequences() {
  "$@" | sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g'
}

if ! command -v tput >/dev/null; then
  tput() {
    printf '1000\n'
  }
  export -f tput
fi

emit_debug_output() {
  # shellcheck disable=SC2154
  printf '%s\n' 'output:' "$output" >&2
}

run_under_clean_bats_env() {
  # we want the variable names to be separate
  # shellcheck disable=SC2086
  unset ${!BATS_@}
  "$@"
}

#!/usr/bin/env bash

# `SECRET_PROJECT_ROOT` must be set before running the script.

set -e

TEST_DIR=/tmp/git-secret-test

rm -rf "${TEST_DIR}"
mkdir "${TEST_DIR}"
echo "# created dir: ${TEST_DIR}"

chmod 0700 "${TEST_DIR}"
(
    cd "$TEST_DIR"

    # test with non-standard SECRETS_DIR (normally .gitsecret)
    # and SECRETS_EXTENSION (normally .secret)
    export SECRETS_DIR='.gitsec'
    export SECRETS_EXTENSION='.sec'

    export TMPDIR="$TEST_DIR"
    echo "# TMPDIR is $TMPDIR"

    # bats expects diagnostic lines to be sent to fd 3, matching regex '^# '
    #  (IE, like: `echo '# message here' >&3`).
    # bats ... 3>&1 shows diagnostic output
    bats "${SECRET_PROJECT_ROOT}/tests" 3>&1
)

rm -rf "${TEST_DIR}"

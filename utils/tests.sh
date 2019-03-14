#!/usr/bin/env bash

set -e
# `SECRET_PROJECT_ROOT` must be set before running the script.
[ -z "${SECRET_PROJECT_ROOT}" ] && exit 1

function cleanup {
    rm -rf "${TEST_RUN_DIR}" "${TEST_TMP_DIR}"
    exit "$1"
}

trap cleanup EXIT

# Running all the bats-tests in a dir with spaces:
TEST_RUN_DIR="${SECRET_PROJECT_ROOT:?}/tempdir with spaces"
TEST_TMP_DIR="${TMPDIR:=/tmp}/git-secret-bats-tmp"

rm -rf "${TEST_RUN_DIR}" "${TEST_TMP_DIR}"
mkdir -p "${TEST_RUN_DIR}" "${TEST_TMP_DIR}"
cd "${TEST_RUN_DIR}"

# test with non-standard SECRETS_DIR (normally .gitsecret) and SECRETS_EXTENSION (normally .secret)
export SECRETS_DIR=.gitsecret-testdir
export SECRETS_EXTENSION=.secret2
#export SECRETS_VERBOSE=''

# bats expects diagnostic lines to be sent to fd 3, matching regex '^ #' (IE, like: `echo '# message here' >&3`)
# bats ... 3>&1 shows diagnostic output when errors occur.
TMPDIR="${TEST_TMP_DIR}" bats "${SECRET_PROJECT_ROOT}/tests/" 3>&1
status=$?
cleanup $status

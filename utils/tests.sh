#!/usr/bin/env bash

# `SECRET_PROJECT_ROOT` must be set before running the script.

set -e

TMP_SUBDIR="tempdir"
cd "${SECRET_PROJECT_ROOT}"; rm -rf "$TMP_SUBDIR"; mkdir "$TMP_SUBDIR"; cd "$TMP_SUBDIR"


# test with non-standard SECRETS_DIR (normally .gitsecret) and SECRETS_EXTENSION (normally .secret)
export SECRETS_DIR=.gitsecret-testdir
export SECRETS_EXTENSION=.secret2
#export SECRETS_VERBOSE=''

export TMPDIR="${SECRET_PROJECT_ROOT}/${TMP_SUBDIR}"
echo "# TMPDIR is $TMPDIR" 

# bats expects diagnostic lines to be sent to fd 3, matching regex '^ #' (IE, like: `echo '# message here' >&3`)
# bats ... 3>&1 shows diagnostic output when errors occur.
#bats "${SECRET_PROJECT_ROOT}/tests/test_init.bats" 3>&1
bats "${SECRET_PROJECT_ROOT}/tests/" 3>&1

cd ..; rm -rf "$TMPDIR"
trap 'echo "# git-secret: cleaning up $TMPDIR" >&3; rm -rf "$TMPDIR";' EXIT

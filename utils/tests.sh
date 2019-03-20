#!/usr/bin/env bash

# `SECRET_PROJECT_ROOT` must be set before running the script.

set -e

#TEST_DIR="/tmp/tempdir with spaces"
TEST_DIR="/tmp/tempdir"

# make sure tmp doesn't have a git setup
rm -rf /tmp/.git
rm -f  /tmp/.gitignore
rm -rf /tmp/.gitsecret

rm -rf "${TEST_DIR}"
mkdir "${TEST_DIR}"
chmod 0700 "${TEST_DIR}"
cd "${TEST_DIR}"

# test with non-standard SECRETS_DIR (normally .gitsecret) and SECRETS_EXTENSION (normally .secret)
export SECRETS_DIR=.gitsecret-testdir
export SECRETS_EXTENSION=.secret2
#export SECRETS_VERBOSE=''

export TMPDIR="${TEST_DIR}"
echo "# TMPDIR is $TMPDIR"

# bats expects diagnostic lines to be sent to fd 3, matching regex '^ #' (IE, like: `echo '# message here' >&3`)
# bats ... 3>&1 shows diagnostic output when errors occur.
bats "${SECRET_PROJECT_ROOT}/tests/" 3>&1

# NOW, create a git repo in /tmp  and run the tests again. We'll see failures
(cd /tmp; git init)
bats "${SECRET_PROJECT_ROOT}/tests/" 3>&1

# cleanup
cd ..; rm -rf "${TEST_DIR}"
trap 'echo "# git-secret: cleaning up ${TEST_DIR}"; rm -rf "${TEST_DIR}";' EXIT

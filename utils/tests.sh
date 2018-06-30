#!/usr/bin/env bash

# `SECRET_PROJECT_ROOT` must be set before running the script.

set -e

## Running all the bats-tests:
#cd "${SECRET_PROJECT_ROOT}"; rm -rf temp; mkdir temp; cd temp;
#bats "${SECRET_PROJECT_ROOT}/tests"

# Running all the bats-tests:
cd "${SECRET_PROJECT_ROOT}"; rm -rf 'tempdir with spaces'; mkdir 'tempdir with spaces'; cd 'tempdir with spaces';
bats "${SECRET_PROJECT_ROOT}/tests"

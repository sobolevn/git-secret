#!/usr/bin/env bash

set -e

function run_kitchen_tests {
  ansible --version
  ruby --version
  python --version
  pip --version
  bundler --version
  bundle show
  bundle exec kitchen test --test-base-path="$PWD/.ci/integration" $KITCHEN_REGEXP
}

# Only running `make test` on standard (non-docker) builds,
# since it is called inside the docker container anyway.

# Local builds:
if [[ "$GITSECRET_DIST" == "brew" ]]; then
  make lint && echo 'make lint: test passed' || echo 'make lint: test failed'
  make test
fi
if [[ "$GITSECRET_DIST" == "windows" ]]; then
  make test
fi

# Linux:
if [[ "$TRAVIS_OS_NAME" == "linux" ]] && [[ -n "$KITCHEN_REGEXP" ]]; then
  run_kitchen_tests
fi

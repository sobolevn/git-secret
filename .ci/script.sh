#!/usr/bin/env bash

set -e

# Docker-baised builds:
if [[ ! -z "$DOCKER_DIST" ]]; then
  TEMPLATE="sobolevn/git-secret-docker-$DOCKER_DIST"
  # Passing the `TRAVIS_COMMIT` into the container:
  COMMAND="if [ ! -z ${TRAVIS_COMMIT} ]; then git checkout ${TRAVIS_COMMIT}; fi; make test-${GITSECRET_DIST}-ci"

  # This will run the full intergration check inside the `docker` container:
  # see `test-deb-ci` and `test-rpm-ci` in `Makefile`
  docker run "$TEMPLATE" /bin/bash -c "$COMMAND"
  docker ps -a
fi

# Local builds:
if [[ -z "$DOCKER_DIST" ]]; then
  # Only running `make test` on standard (non-docker) build,
  # since it is called inside the docker container anyway.
  make test
fi

if [[ ! -z "$(command -v shellcheck)" ]]; then
  # This means, that `shellcheck` does exist, so run it:
  echo 'running lint'
  find src -type f -name '*.sh' -print0 | xargs -0 -I {} shellcheck {}
  find utils -type f -name '*.sh' -print0 | xargs -0 -I {} shellcheck {}
  # TODO: add tests to lint
  # see: https://github.com/koalaman/shellcheck/issues/709
fi

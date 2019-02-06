#!/usr/bin/env bash

set -e

BRANCH_NAME=$(git branch | grep '\*' | sed 's/* //')

if [[ "$BRANCH_NAME" != '(no branch)' ]]; then
  unset GIT_WORK_TREE

  # Set marker, that we running tests from `git commit`,
  # so some tests will be skipped. It is done, because `git rev-parse`
  # is not working when running from pre-commit hook. See #334
  export BATS_RUNNING_FROM_GIT=1

  # Run tests:
  make test

  if [[ "$BRANCH_NAME" == "master" ]]; then
    # Build new manuals:
    make build-man

    # Add new files:
    git add man/man1/*
    git add man/man7/*
  fi
fi

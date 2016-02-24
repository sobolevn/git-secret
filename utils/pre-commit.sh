#!/usr/bin/env bash

set -e

BRANCH_NAME=$(git branch | grep '*' | sed 's/* //')

if [[ $BRANCH_NAME != '(no branch)' ]]; then
  unset GIT_WORK_TREE

  # Run tests:
  make test

  if [[ $BRANCH_NAME == "master" ]]; then
    # Build new manuals:
    make build-man

    # Add new files:
    git add man/man1/*
  fi
fi

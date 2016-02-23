#!/usr/bin/env bash

set -e


function update_gh_branch {
  git checkout gh-pages
  make

  git add --all
  git commit -m 'documentation update'
}

update_gh_branch

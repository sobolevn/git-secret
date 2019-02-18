#!/usr/bin/env bash

set -e


function update_gh_branch {
  local branch_name

  branch_name=$(git branch | grep '\*' | sed 's/* //')

  git checkout 'gh-pages'
  make

  git add --all '_posts'
  git commit -m 'documentation update'
  git checkout "$branch_name"
}

update_gh_branch

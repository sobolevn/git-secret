#!/usr/bin/env bash

set -e


function update_gh_branch {
  git checkout gh-pages
  make

  git add _posts
  git commit -m 'documentation update'
  git checkout master
}

update_gh_branch

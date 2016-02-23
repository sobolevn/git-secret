#!/usr/bin/env bash

function update_gh_branch {
  git checkout gh-pages
  make
}

update_gh_branch

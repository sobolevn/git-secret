#!/usr/bin/env bash

set -e

MAN_LOCATION="man/man1"
POSTS_LOCATION="_posts"


function checkout_manuals {
  git checkout master "$MAN_LOCATION"

  rm -f $MAN_LOCATION/*.1
}


function copy_to_posts {
  # Cleaning old files:
  rm -f $POSTS_LOCATION/*.md

  # Moving new command files:
  local timestamp=$(date "+%Y-%m-%d %H:%M:%S %z")
  echo "$current_date"

  for com in $MAN_LOCATION/git-secret-*.1.ronn; do
    local short_name=$(echo "$com" | sed -n "s|$MAN_LOCATION/\(.*\)\.1\.ronn|\1|p")
    local command_header="---
layout: post
title:  '${short_name}'
date:   ${timestamp}
categories: command
---"

    local current_date=$(date "+%Y-%m-%d")
    local post_filename="$POSTS_LOCATION/${current_date}-${short_name}.md"
    echo "$command_header" > "$post_filename"
    cat "$com" >> "$post_filename"
  done
}

checkout_manuals
copy_to_posts

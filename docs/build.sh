#!/usr/bin/env bash

# Should be called from the root folder, not inside `docs/` folder
# See `make build-docs`

set -e

MAN_LOCATION='man/man1'
MAN7_LOCATION='man/man7'
POSTS_LOCATION='docs/_posts'


function checkout_manuals {
  cp -r man/ docs/man
}


function copy_to_posts {
  # Cleaning old files:
  rm -f "$POSTS_LOCATION/*.md"
  rm -rf "$POSTS_LOCATION"
  mkdir -p "$POSTS_LOCATION"

  # Moving new command files:
  local timestamp
  local current_date

  timestamp=$(date "+%Y-%m-%d %H:%M:%S %z")
  current_date=$(date "+%Y-%m-%d")

  # Creating command refernce:
  for com in "$MAN_LOCATION"/git-secret-*.1.md; do
    local short_name
    short_name=$(echo "$com" | sed -n "s|$MAN_LOCATION/\(.*\)\.1\.md|\1|p")
    local command_header="---
layout: post
title: '${short_name}'
date: ${timestamp}
permalink: ${short_name}
categories: command
---"

    local post_filename="$POSTS_LOCATION/${current_date}-${short_name}.md"
    echo "$command_header" > "$post_filename"
    cat "$com" >> "$post_filename"
  done

  # Creating main usage file:
  local usage_header="---
layout: post
title: 'git-secret'
date: ${timestamp}
permalink: git-secret
categories: usage
---"
  local usage_filename="$POSTS_LOCATION/${current_date}-git-secret.md"
  echo "$usage_header" > "$usage_filename"
  cat "$MAN7_LOCATION/git-secret.7.md" >> "$usage_filename"
}


function copy_install_scripts {
  # We test these scripts using `release-ci`,
  # so, installation instructions will always be up-to-date:
  cp utils/deb/install.sh docs/_includes/install-deb.sh
  cp utils/rpm/install.sh docs/_includes/install-rpm.sh
  cp utils/apk/install.sh docs/_includes/install-apk.sh
}


function copy_version {
   echo "$(./git-secret --version)" > docs/_includes/version.txt
}


checkout_manuals
copy_to_posts
copy_install_scripts
copy_version

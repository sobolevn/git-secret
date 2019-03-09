#!/bin/bash
#
# This script creates a draft release that is only visible to collaborators. 
# You then need to login to GitHub to check the draft release and publish it. 
# This secript uses github_changelog_generator to generate a change log that 
# names bugs, enhancement and PRs. That requires that this script guesses what 
# the last release was to compute the delta from. That logic the naive calculation
# of LAST_RELEASE_TAG which looks for the previous /v.*/ tag. The script requires
# an enviroment variable GITHUB_OAUTH_TOKEN that has write access to the repo in 
# question. 
#
# https://github.com/travis-ci/dpl/issues/155
# https://gist.github.com/Jaskaranbir/d5b065173b3a6f164e47a542472168c1

# ===> Set these variables first
branch="$GIT_BRANCH"
# Example: "Jaskaranbir/MyRepo"
repo_slug="$TRAVIS_REPO_SLUG"
token="$GITHUB_OAUTH_TOKEN"
version="$TRAVIS_TAG"

# An automatic changelog generator
gem install github_changelog_generator

LAST_RELEASE_TAG=$(git tag | grep 'v.*' | tail -2 | head -1)

# Generate CHANGELOG.md
github_changelog_generator \
  -u $(cut -d "/" -f1 <<< $repo_slug) \
  -p $(cut -d "/" -f2 <<< $repo_slug) \
  --token $token \
  --since-tag ${LAST_RELEASE_TAG}

body="$(cat CHANGELOG.md)"

# Overwrite CHANGELOG.md with JSON data for GitHub API
jq -n \
  --arg body "$body" \
  --arg name "$version" \
  --arg tag_name "$version" \
  --arg target_commitish "$branch" \
  '{
    body: $body,
    name: $name,
    tag_name: $tag_name,
    target_commitish: $target_commitish,
    draft: true,
    prerelease: false
  }' > CHANGELOG.md

echo "Create release $version for repo: $repo_slug, branch: $branch"
curl -H "Authorization: token $token" --data @CHANGELOG.md "https://api.github.com/repos/$repo_slug/releases"
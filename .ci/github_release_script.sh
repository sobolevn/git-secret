#!/usr/bin/env sh

set -e

# Installing additional deps:
apk add --no-cache curl jq

# https://gist.github.com/Jaskaranbir/d5b065173b3a6f164e47a542472168c1
USER="$(echo "$GITHUB_REPOSITORY" | cut -d "/" -f1)"
PROJECT="$(echo "$GITHUB_REPOSITORY" | cut -d "/" -f2)"

LAST_RELEASE_TAG=$(curl \
    --header "authorization: Bearer $GITHUB_TOKEN" \
    --url "https://api.github.com/repos/$GITHUB_REPOSITORY/releases/latest" \
  | jq .tag_name | sed 's/"//g'
)
echo "LAST_RELEASE_TAG=$LAST_RELEASE_TAG"
if [ "$LAST_RELEASE_TAG" = 'null' ]; then
  # Most likely, we are facing rate-limiting problems,
  # just try again later.
  exit 1
fi

NEW_CHANGELOG='CHANGELOG-RELEASE.md'

# Generate new CHANGELOG.md with just the last changes
github_changelog_generator \
  --user "$USER" \
  --project "$PROJECT" \
  --token "$GITHUB_OAUTH_TOKEN" \
  --since-tag "$LAST_RELEASE_TAG" \
  --max-issues 450 \
  --no-issues \
  --release-branch 'master' \
  --token "$GITHUB_TOKEN" \
  --output "$NEW_CHANGELOG"

echo 'Done! Changelog:'
cat "$NEW_CHANGELOG"

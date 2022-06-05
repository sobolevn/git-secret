#!/usr/bin/env bash

set -e

if [[ "$SECRETS_DEPLOY_DRY_RUN" == 1 ]]; then
  echo 'dry-run finished'
  exit 0
fi

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"

# Artifactory location:
readonly BASE_API_URL='https://gitsecret.jfrog.io/artifactory'

# This folder should contain just one `.dev` file:
DEB_FILE_LOCATION="$(locate_release 'deb')"
DEB_FILE_NAME="$(basename "$DEB_FILE_LOCATION")"


curl -sS \
  -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  -XPUT "$BASE_API_URL/git-secret-deb/$DEB_FILE_NAME;deb.distribution=git-secret;deb.component=main;deb.architecture=all" \
  -T "$DEB_FILE_LOCATION"

# Now, we need to trigger metadata reindex:
curl -sS \
  -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  -XPOST "$BASE_API_URL/api/deb/reindex/git-secret-deb"

echo
echo "Done: released $DEB_FILE_NAME"

#!/usr/bin/env bash

set -e

if [ -z "$SECRETS_ARTIFACTORY_CREDENTIALS" ]; then
  echo '$SECRETS_ARTIFACTORY_CREDENTIALS is not set'
  exit 1
fi

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"

# Artifactory location:
BASE_API_URL='https://gitsecret.jfrog.io/artifactory'

# This folder should contain just one `.rpm` file:
RPM_FILE_LOCATION="$(locate_release 'rpm')"
RPM_FILE_NAME="$(basename "$RPM_FILE_LOCATION")"


curl -sS -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  -XPUT "$BASE_API_URL/git-secret-rpm/rpm/$RPM_FILE_NAME" \
  -T "$RPM_FILE_LOCATION"

# Now, we need to trigger metadata reindex:
curl -sS -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  -XPOST "$BASE_API_URL/api/yum/git-secret-rpm?async=1"

echo
echo "Done: released $RPM_FILE_NAME"

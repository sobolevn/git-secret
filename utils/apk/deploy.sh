#!/usr/bin/env bash

set -e

if [ -z "$SECRETS_ARTIFACTORY_CREDENTIALS" ]; then
  echo '$SECRETS_ARTIFACTORY_CREDENTIALS is not set'
  exit 1
fi

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"

VERSION_NAME="git-secret-${SCRIPT_VERSION}.apk"

# Artifactory location:
BASE_API_URL='https://gitsecret.jfrog.io/artifactory'

# This folder should contain just one `.apk` file:
APK_FILE_LOCATION="$(locate_release 'apk')"
APK_FILE_NAME="$(basename "$APK_FILE_LOCATION")"


function upload_with_architecture {
  local arch="$1"

  curl -sS -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
    --max-time 10 \
    --retry 3 \
    --retry-delay 5 \
    -XPUT "$BASE_API_URL/git-secret-apk/all/main/$arch/$VERSION_NAME" \
    -T "$APK_FILE_LOCATION"
}

# Full list is here:
# http://dl-cdn.alpinelinux.org/alpine/v3.13/main/
ARCHITECTURES=(
  'aarch64'
  'armhf'
  'armv7'
  'mips64'
  'ppc64le'
  's390x'
  'x86_64'
  'x86'
)

for architecture in "${ARCHITECTURES[@]}"; do
  upload_with_architecture "$architecture"
done

# Now, we need to trigger metadata reindex:
curl -sS -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  --max-time 5 \
  --retry 3 \
  --retry-delay 5 \
  -XPOST "$BASE_API_URL/api/alpine/git-secret-apk/reindex"

echo
echo "Done: released $APK_FILE_NAME"

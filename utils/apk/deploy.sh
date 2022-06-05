#!/usr/bin/env bash

set -e

if [[ "$SECRETS_DEPLOY_DRY_RUN" == 1 ]]; then
  echo 'dry-run finished'
  exit 0
fi

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/build-utils.sh"
# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/utils/apk/meta.sh"

readonly VERSION_NAME="git-secret-${SCRIPT_VERSION}.apk"

# Artifactory location:
readonly BASE_API_URL='https://gitsecret.jfrog.io/artifactory'


function upload_with_architecture {
  local arch="$1"
  local file_location
  file_location="$(locate_release 'apk' "$arch")"

  curl -sS \
    -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
    --max-time 10 \
    --retry 3 \
    --retry-delay 5 \
    -XPUT "$BASE_API_URL/git-secret-apk/latest-stable/main/$arch/$VERSION_NAME" \
    -T "$file_location"
}

for architecture in "${ALPINE_ARCHITECTURES[@]}"; do
  upload_with_architecture "$architecture"
done

# Now, we need to trigger metadata reindex:
curl -sS \
  -u "$SECRETS_ARTIFACTORY_CREDENTIALS" \
  --max-time 5 \
  --retry 3 \
  --retry-delay 5 \
  -XPOST "$BASE_API_URL/api/alpine/git-secret-apk/reindex"

echo
echo 'Done: released alpine packages'

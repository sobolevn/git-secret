#!/usr/bin/env bash

set -e

# This file is required, because for some reason
# travis deploys do not trigger metadata calculation.
# See: https://github.com/sobolevn/git-secret/issues/89

# This file is only called after successful deploy.

# We need to execute custom call to the Bintray API:
curl -X POST \
  --user "sobolevn:$BINTRAY_API_KEY" \
  -H "X-GPG-PASSPHRASE: $BINTRAY_GPG_PASS" \
  "https://api.bintray.com/calc_metadata/sobolevn/$GITSECRET_DIST"

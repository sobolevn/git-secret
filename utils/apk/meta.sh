# Full list is here:
# http://dl-cdn.alpinelinux.org/alpine/v3.13/main/
# shellcheck disable=SC2034
readonly ALPINE_ARCHITECTURES=(
  # We only support popular arches:
  'x86'
  'x86_64'
)

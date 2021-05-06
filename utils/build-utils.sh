#!/usr/bin/env bash

set -e

# shellcheck disable=SC1090,SC1091
source "$SECRETS_PROJECT_ROOT/src/version.sh"

# Initializing and settings:
READ_PERM=0644
EXEC_PERM=0755

SCRIPT_NAME='git-secret'
SCRIPT_DESCRIPTION='A bash-tool to store your private data inside a git repository.'
SCRIPT_VERSION="$GITSECRET_VERSION"

# This may be overridden:
if [[ -z "$SCRIPT_BUILD_DIR" ]]; then
  SCRIPT_BUILD_DIR="$PWD/build"
fi

SCRIPT_DEST_DIR="$SCRIPT_BUILD_DIR/buildroot"


function locate_release {
  local release_type="$1"
  local arch="${2:-all}"

  find "$SCRIPT_DEST_DIR" \
    -maxdepth 1 \
    -name "*${arch}.$release_type" | head -1
}


function preinstall_files {
  # Only requires `-T` or `-c` depending on the OS
  local dir_switch="$1"

  # Preparing the files:
  rm -rf "$SCRIPT_BUILD_DIR"
  mkdir -p "$SCRIPT_DEST_DIR"

  # Coping the files inside the build folder:
  install -D "$dir_switch" \
    -b -m "$EXEC_PERM" "$dir_switch" "$SCRIPT_NAME" \
    "$SCRIPT_BUILD_DIR/usr/bin/$SCRIPT_NAME"

  # Install the manualls:
  install -m "$EXEC_PERM" -d "$SCRIPT_BUILD_DIR/usr/share/man/man1"
  install -m "$EXEC_PERM" -d "$SCRIPT_BUILD_DIR/usr/share/man/man7"
  for file in man/man1/*.1 ; do
    install -D "$dir_switch" \
      -b -m "$READ_PERM" "$dir_switch" "$file" \
      "$SCRIPT_BUILD_DIR/usr/share/$file"
  done
  install -D "$dir_switch" \
    -b -m "$READ_PERM" "$dir_switch" 'man/man7/git-secret.7' \
    "$SCRIPT_BUILD_DIR/usr/share/man/man7/git-secret.7"
}


function build_package {
  # Only requires `rpm`, `apk`, or `deb` as first argument:
  local build_type="$1"
  local arch_type="${2:-all}"

  # coreutils is for sha256sum
  # See https://github.com/jordansissel/fpm for docs:
  fpm \
    --input-type 'dir' \
    --output-type "$build_type" \
    --chdir "$SCRIPT_BUILD_DIR" \
    --architecture "$arch_type" \
    --name "$SCRIPT_NAME" \
    --version "$SCRIPT_VERSION" \
    --description "$SCRIPT_DESCRIPTION" \
    --url 'https://git-secret.io' \
    --maintainer 'Nikita Sobolev (mail@sobolevn.me)' \
    --license 'MIT' \
    --depends 'bash' \
    --depends 'coreutils' \
    --depends 'gawk' \
    --depends 'git' \
    --depends 'gnupg' \
    --deb-no-default-config-files \
    .
}


function clean_up_files {
  # Pre-installed files:
  rm -rf "${SCRIPT_BUILD_DIR:?}/usr"
  # nfpm configs:
  rm -rf "$SCRIPT_BUILD_DIR"/*.yml
}

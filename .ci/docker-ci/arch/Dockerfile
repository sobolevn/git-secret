FROM archlinux:latest

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN pacman -Syu --needed --noconfirm \
  # Direct dependencies:
  bash \
  gawk \
  git \
  gnupg \
  diffutils \
  # Assumed to be present:
  file \
  make \
  procps


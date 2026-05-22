FROM archlinux/archlinux:base-20221113.0.102202

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN pacman -Syu --needed --noconfirm \
  # Direct dependencies:
  bash \
  gawk \
  git \
  gnupg \
  # Assumed to be present:
  diffutils \
  file \
  make \
  procps


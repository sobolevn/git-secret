FROM archlinux:base-20220529.0.58327

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN pacman -Sy --noconfirm archlinux-keyring \
  && pacman -Su \
  && pacman -Syu --needed --noconfirm \
  # Direct dependencies:
  bash \
  gawk \
  git \
  #gnupg \
  # Assumed to be present:
  diffutils \
  file \
  make \
  procps


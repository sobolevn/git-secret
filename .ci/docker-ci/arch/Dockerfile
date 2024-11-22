FROM archlinux:base-20220529.0.58327

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

WORKDIR /build

COPY PKGBUILD .

# Build the package
RUN makepkg --noconfirm

# Clean up unnecessary files and packages to reduce the image size
RUN rm -rf /var/cache/pacman/pkg/* && \
    pacman -Rns --noconfirm $(pacman -Qdtq)

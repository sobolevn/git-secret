FROM fedora:42

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN dnf -y update \
  && dnf install -y \
    # Direct dependencies:
    bash \
    gawk \
    git \
    gnupg \
    # Assumed to be present:
    diffutils \
    file \
    findutils \
    procps \
    make \
  && dnf clean all \
  && rm -rf /var/cache/yum

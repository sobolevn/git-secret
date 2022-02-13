FROM rockylinux:8

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN dnf -y update \
  && dnf install -y \
    # Required for our install script:
    wget \
    sudo \
  && dnf clean all \
  && rm -rf /var/cache/yum

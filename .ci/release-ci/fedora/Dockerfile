FROM fedora:36

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

RUN dnf -y update \
  && dnf install -y \
    # Required for our install script:
    wget \
    sudo \
  && dnf clean all \
  && rm -rf /var/cache/yum \
  && adduser --password='' -m nonroot \
  && echo 'nonroot ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER nonroot
WORKDIR /home/nonroot

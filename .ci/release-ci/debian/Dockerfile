FROM debian:11.4-slim

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

ENV DEBIAN_FRONTEND='noninteractive'

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    # Required to work with https-based repos and custom signed packages:
    apt-transport-https \
    ca-certificates \
    # Required for our install script:
    gnupg \
    sudo \
    wget \
  # Cleaning cache:
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  && adduser --disabled-password nonroot \
  && adduser nonroot sudo \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER nonroot

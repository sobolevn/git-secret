FROM ubuntu:23.10

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    # Direct dependencies:
    gawk \
    git \
    gnupg \
    # Assumed to be present:
    file \
    procps \
    make \
  # Cleaning cache:
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

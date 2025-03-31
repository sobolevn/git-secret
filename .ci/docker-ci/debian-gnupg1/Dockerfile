FROM debian:12.10-slim

LABEL maintainer="mail@sobolevn.me"
LABEL vendor="git-secret team"

ENV DEBIAN_FRONTEND='noninteractive'
ENV SECRETS_GPG_COMMAND='gpg1'

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    # Direct dependencies:
    gawk \
    git \
    gnupg1 \
    # Assumed to be present:
    file \
    procps \
    make \
  # Cleaning cache:
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

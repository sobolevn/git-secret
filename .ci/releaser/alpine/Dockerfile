# Initially copied from
# https://github.com/jordansissel/fpm/blob/master/Dockerfile
FROM alpine:3.16.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV CODE_DIR='/code'
ENV SECRETS_PROJECT_ROOT="$CODE_DIR"

RUN apk add --no-cache --update \
    # fpm deps:
    ruby \
    ruby-dev \
    ruby-etc \
    gcc \
    libffi-dev \
    make \
    libc-dev \
    rpm \
    tar \
    # Direct dependencies:
    bash \
    gawk \
    git \
    gnupg \
    # Assumed to be present:
    curl \
    # envsubst for `nfpm`:
    gettext \
  # Installing `nfpm`, it builds alpine packages:
  && curl -sfL https://install.goreleaser.com/github.com/goreleaser/nfpm.sh | sh \
  # Installing `fpm`, it builds all other packages:
  && gem install --no-document fpm

WORKDIR $CODE_DIR

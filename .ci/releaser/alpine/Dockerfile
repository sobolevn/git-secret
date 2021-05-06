# Initially copied from
# https://github.com/jordansissel/fpm/blob/master/Dockerfile

# TODO: Move to native image
# see: https://github.com/jordansissel/fpm/issues/1782
# Or we can completely switch to
# https://github.com/goreleaser/nfpm
FROM alpine:3.13

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
  # Installing `nfpm`, it builds alpine packages:
  && curl -sfL https://install.goreleaser.com/github.com/goreleaser/nfpm.sh | sh \
  # Installing `fpm`, it build all other packages:
  && gem install --no-document fpm

WORKDIR $CODE_DIR

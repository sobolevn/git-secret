# Initially copied from
# https://github.com/jordansissel/fpm/blob/master/Dockerfile

# TODO: Move to native image
# see: https://github.com/jordansissel/fpm/issues/1782
# Or we can switch to
# https://github.com/goreleaser/nfpm
FROM alpine:3.13

ENV CODE_DIR='/code'
ENV SECRET_PROJECT_ROOT="$CODE_DIR"

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
  curl

# Installing fpm:
RUN gem install --no-document fpm

WORKDIR $CODE_DIR

# Initially copied from
# https://github.com/jordansissel/fpm/blob/master/Dockerfile
FROM alpine:3.20.1

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

ENV CODE_DIR='/code'
ENV SECRETS_PROJECT_ROOT="$CODE_DIR"
ENV NFPM_VERSION='2.15.1'

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
  && curl -sfL "https://github.com/goreleaser/nfpm/releases/download/v${NFPM_VERSION}/nfpm_${NFPM_VERSION}_Linux_x86_64.tar.gz" --output 'nfpm.tar.gz' \
  && tar -xf 'nfpm.tar.gz' nfpm \
  && mv nfpm '/usr/local/bin' \
  && chmod 755 '/usr/local/bin/nfpm' \
  && rm -rf 'nfpm.tar.gz' \
  # Installing `fpm`, it builds all other packages:
  && gem install --no-document fpm

WORKDIR $CODE_DIR

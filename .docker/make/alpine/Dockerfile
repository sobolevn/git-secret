FROM alpine:latest

MAINTAINER Nikita Sobolev (mail@sobolevn.me)

# Dependencies and project initialization:

RUN apk add --no-cache --update \
  man make git ruby ruby-dev bash ruby-bundler \
  ca-certificates libressl libressl-dev build-base
RUN mkdir /code

# This will increase the container size, but speed up the build,
# since this part will change, while the dependencies won't:

WORKDIR /code

# Removing `origin` for good:

RUN git clone -q https://github.com/sobolevn/git-secret.git && \
    cd git-secret && git remote rm origin

WORKDIR /code/git-secret

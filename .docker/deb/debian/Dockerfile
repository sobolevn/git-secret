FROM debian:latest

MAINTAINER Nikita Sobolev (mail@sobolevn.me)

# Dependencies and project initialization:

RUN apt-get update && \
    apt-get install -y man make git apt-transport-https && \
    apt-get install -y ruby ruby-dev ruby-build && \
    apt-get autoremove && apt-get autoclean

# This will increase the container size, but speed up the build,
# since this part will change, while the dependencies won't:

RUN mkdir /code
WORKDIR /code

# Removing `origin` for good:

RUN git clone -q https://github.com/sobolevn/git-secret.git && \
    cd git-secret && git remote rm origin

WORKDIR /code/git-secret

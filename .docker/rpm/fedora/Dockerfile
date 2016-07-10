FROM fedora:latest

MAINTAINER Nikita Sobolev (mail@sobolevn.me)

ENV HOME /root

RUN dnf update -y && \
    dnf install -y gnupg man make gcc git tar > /dev/null && \
    dnf install -y which pciutils redhat-rpm-config rpm-build zlib-devel && \
    dnf -y group install 'Development tools' && \
    dnf install -y ruby ruby-devel rubygems && \
    dnf -y autoremove && \
    mkdir /code

WORKDIR /code

# Removing `origin` for good:

RUN git clone -q https://github.com/sobolevn/git-secret.git && \
    cd git-secret && git remote rm origin

WORKDIR /code/git-secret

FROM alpine:latest

RUN apk add --no-cache --update \
	bash \
	build-base \
	coreutils \
	curl \
	findutils \
	gcc \
	libffi-dev \
	musl-dev \
	net-tools \
	openrc \
	openssh \
	openssh-server \
	openssh-sftp-server \
	openssl-dev \
	py-boto \
	py-pip \
	python3-dev \
	rsyslog \
	sudo \
	xz \
 && pip3 install --upgrade pip \
 && if ! getent passwd <%= @username %>; then \
      adduser -h /home/<%= @username %> -s /bin/bash -D <%= @username %>; \
      passwd -d <%= @username %>; \
    fi \
 && echo "<%= @username %> ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "Defaults !requiretty" >> /etc/sudoers \
 && mkdir -p /home/<%= @username %>/.ssh \
 && chown -R <%= @username %> /home/<%= @username %>/.ssh \
 && chmod 0700 /home/<%= @username %>/.ssh \
 && echo '<%= IO.read(@public_key).strip %>' >> /home/<%= @username %>/.ssh/authorized_keys \
 && chown <%= @username %> /home/<%= @username %>/.ssh/authorized_keys \
 && chmod 0600 /home/<%= @username %>/.ssh/authorized_keys \
 && sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?ChallengeResponseAuthentication\s+.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?UsePrivilegeSeparation\s+.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config \
 && echo "UseDNS=no" >> /etc/ssh/sshd_config \
 && rc-update add sshd

EXPOSE 22

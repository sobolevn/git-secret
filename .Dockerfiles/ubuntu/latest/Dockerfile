FROM ubuntu:latest

ENV DEBIAN_FRONTEND="noninteractive" container="docker" SECRETS_TEST_VERBOSE=1

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
	apt-utils \
	curl \
	locales \
	lsb-release \
	net-tools \
	openssh-server \
	python-pip \
	python2.7 \
	sudo \
	systemd \
 && pip install --upgrade pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && if ! getent passwd <%= @username %>; then \
      useradd -d /home/<%= @username %> -m -s /bin/bash -p '*' <%= @username %>; \
    fi \
 && echo "<%= @username %> ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "Defaults !requiretty" >> /etc/sudoers \
 && mkdir -p /home/<%= @username %>/.ssh \
 && chown -R <%= @username %> /home/<%= @username %>/.ssh \
 && chmod 0700 /home/<%= @username %>/.ssh \
 && echo '<%= IO.read(@public_key).strip %>' >> /home/<%= @username %>/.ssh/authorized_keys \
 && chown <%= @username %> /home/<%= @username %>/.ssh/authorized_keys \
 && chmod 0600 /home/<%= @username %>/.ssh/authorized_keys \
 && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && /usr/sbin/locale-gen \
 && cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
 && /bin/rm -f /lib/systemd/system/multi-user.target.wants/* \
 && /bin/rm -f /etc/systemd/system/*.wants/* \
 && /bin/rm -f /lib/systemd/system/local-fs.target.wants/* \
 && /bin/rm -f /lib/systemd/system/sockets.target.wants/*udev* \
 && /bin/rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
 && /bin/rm -f /lib/systemd/system/basic.target.wants/* \
 && /bin/rm -f /lib/systemd/system/anaconda.target.wants/*  \
 && /bin/rm -f /lib/systemd/system/plymouth* \
 && /bin/rm -f /lib/systemd/system/systemd-update-utmp* \
 && sed -ri 's/^#?UsePAM\s+.*/UsePAM no/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?UsePrivilegeSeparation\s+.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config \
 && echo "UseDNS=no" >> /etc/ssh/sshd_config \
 && systemctl set-default multi-user.target \
 && ln -s /lib/systemd/system/ssh.service /etc/systemd/system/multi-user.target.wants/ssh.service \
 && ln -s /lib/systemd/system/systemd-journald.service /etc/systemd/system/multi-user.target.wants/systemd-journald.service \
 && echo $'[Unit]\
\nDescription=Finish boot up\
\nAfter=ssh.service\
\n\
\n[Service]\
\nType=oneshot\
\nRemainAfterExit=yes\
\nExecStartPre=/bin/sleep 3s\
\nExecStart=/bin/rm -f /run/nologin\
\n\
\n[Install]\
\nWantedBy=default.target' >> /etc/systemd/system/FinishBootUp.service \
 && ln -s /etc/systemd/system/FinishBootUp.service /etc/systemd/system/multi-user.target.wants/FinishBootUp.service

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]

FROM fedora:latest

ENV container="docker"

RUN dnf clean all \
 && dnf makecache \
 && dnf install -y \
	curl \
	findutils \
	gcc \
	glibc-langpack-en.x86_64  \
	libffi-devel \
	net-tools \
	openssh-server \
	openssl-devel \
	python3-devel \
	python3-pip \
	redhat-lsb \
	redhat-rpm-config \
	rust cargo \
	sudo \
	systemd \
 && pip3 install --upgrade pip \
 && dnf clean all \
 && if ! getent passwd <%= @username %>; then \
      useradd -d /home/<%= @username %> -m -s /usr/bin/bash -p '*' <%= @username %>; \
    fi \
 && echo "<%= @username %> ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
 && echo "Defaults !requiretty" >> /etc/sudoers \
 && mkdir -p /home/<%= @username %>/.ssh \
 && chown -R <%= @username %> /home/<%= @username %>/.ssh \
 && chmod 0700 /home/<%= @username %>/.ssh \
 && echo '<%= IO.read(@public_key).strip %>' >> /home/<%= @username %>/.ssh/authorized_keys \
 && chown <%= @username %> /home/<%= @username %>/.ssh/authorized_keys \
 && chmod 0600 /home/<%= @username %>/.ssh/authorized_keys \
 && export LANG="en_US.UTF-8" && echo "LANG=\"en_US.UTF-8\"" > /etc/locale.conf \
 && cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | /usr/bin/xargs rm -f $1 \
 && /usr/bin/rm -f /lib/systemd/system/multi-user.target.wants/* \
 && /usr/bin/rm -f /etc/systemd/system/*.wants/* \
 && /usr/bin/rm -f /lib/systemd/system/local-fs.target.wants/* \
 && /usr/bin/rm -f /lib/systemd/system/sockets.target.wants/*udev* \
 && /usr/bin/rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
 && /usr/bin/rm -f /lib/systemd/system/basic.target.wants/* \
 && /usr/bin/rm -f /lib/systemd/system/anaconda.target.wants/*  \
 && /usr/bin/rm -f /lib/systemd/system/plymouth* \
 && /usr/bin/rm -f /lib/systemd/system/systemd-update-utmp* \
 && sed -ri 's/^#?PubkeyAuthentication\s+.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
 && sed -ri 's/^#?UsePrivilegeSeparation\s+.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config \
 && echo "UseDNS=no" >> /etc/ssh/sshd_config \
 && systemctl set-default multi-user.target \
 && ln -s /lib/systemd/system/sshd.service /etc/systemd/system/multi-user.target.wants/sshd.service \
 && ln -s /lib/systemd/system/systemd-journald.service /etc/systemd/system/multi-user.target.wants/systemd-journald.service \
 && echo $'[Unit]\
\nDescription=Finish boot up\
\nAfter=sshd.service\
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

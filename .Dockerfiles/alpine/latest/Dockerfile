FROM alpine:latest

# - build tools are for: fig2dev which is needed by gnupg builds
# - openssh is for scp
# - tini is for PID 1
# - changing alpine from 3.6 to 3.7 is for ansible 2.4,
#   but need to install ansible 2.3 for dependencies first
# - shellcheck is not in the apk repository (xz/tar needed for shellcheck)
# - bundler/rspec is not found on kitchen verify (symlink needed)

RUN apk add --no-cache --update \
	curl net-tools \
	openssh-server openssh \
  sudo bash tini \
  ansible git rsync xz \
	gcc autoconf automake g++ libffi-dev tar libxpm-dev make \
	autoconf automake imagemagick-dev texinfo gettext-dev libgcrypt-dev \
	libgpg-error-dev libassuan-dev libksba-dev npth-dev libxfont-dev \
	libwmf-dev libx11-dev libxt-dev libxext-dev libxml2-dev libexif-dev perl \
	ruby-dev ruby-bundler \
 && ln -s /usr/bin/bundle /usr/local/bin/bundle \
 && ln -s /usr/bin/rspec /usr/local/bin/rspec \
 && sed -i -e 's/v3\.6/v3.7/g' /etc/apk/repositories \
 && apk add --update-cache --upgrade ansible \
 && sed -i -e 's/v3\.7/v3.6/g' /etc/apk/repositories \
 && apk add --update-cache \
 && curl --silent -L -o shellcheck.tar.xz https://storage.googleapis.com/shellcheck/shellcheck-latest.linux.x86_64.tar.xz \
 && tar -vxf shellcheck.tar.xz \
 && mv shellcheck-latest/shellcheck /usr/local/bin/ \
 && sudo mkdir -p /usr/local/src/ \
 && git clone https://github.com/Distrotech/transfig.git && cd transfig \
 && make && make install \
 && cp -R /usr/X11R7/bin/fig2dev /usr/local/bin \
 && if ! getent passwd <%= @username %>; then \
      adduser -h /home/<%= @username %> -s /bin/bash <%= @username %>; \
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
 && sed -ri 's/^#?UsePrivilegeSeparation\s+.*/UsePrivilegeSeparation no/' /etc/ssh/sshd_config \
 && echo "UseDNS=no" >> /etc/ssh/sshd_config \
 && ssh-keygen -A

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]

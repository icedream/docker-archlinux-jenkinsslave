FROM nfnty/arch-mini:latest
MAINTAINER Carl Kittelberger, icedream@icedream.pw



# Install updates + sudo
RUN pacman -Syuu --noconfirm

# install all packages
RUN \
	pacman -S --needed --noconfirm \
		autoconf \
		automake \
		base-devel \
		ca-certificates \
		curl \
		cvs \
		git \
		jre7-openjdk-headless \
		mercurial \
		openssh \
		subversion \
		sudo \
		tar \
		unzip \
		wget \
		xz \
		zip \
		&&\
	trust extract-compat && \
	pacman -Scc --noconfirm

# set up locale
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
	locale-gen en_US && \
	printf 'LANG=en_US.UTF-8\nLC_CTYPE=en_US.UTF-8\n' > /etc/locale.conf
ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# prepare the jenkins user
RUN useradd -m -p x jenkins && \
	mkdir -p /tmp && \
	chmod 777 /tmp && \
	mkdir /home/jenkins/.ssh && \
	chown jenkins:jenkins /home/jenkins/.ssh && \
	chmod 700 /home/jenkins/.ssh

# passwordless sudo for extra package installations, etc.
RUN echo '' >> /etc/sudoers && \
	echo 'jenkins ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# clean up
RUN rm -rf /tmp/* /var/tmp/* /etc/ssh/ssh_host_*

# ssh preparation
RUN mkdir -p /var/run/sshd

COPY start.sh /
RUN chmod +x /start.sh
CMD ["/start.sh"]

# SSH for Jenkins master
EXPOSE 22

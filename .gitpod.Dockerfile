FROM archlinux

## Inital Upgrade and Install First Packages
RUN	pacman-key --init && pacman-key --populate \
&&	pacman -Syyv --needed --noconfirm archlinux-keyring \
&&	pacman -Syuuv --needed --noconfirm \
	base ca-certificates curl gnupg \
	breezy git mercurial openssh subversion procps-ng \
	base-devel \
	autoconf automake bzip2 pacman-contrib file gcc imagemagick glibc db libevent libffi gdbm tdb glib2 gmp-ecm libjpeg-turbo pam-krb5 xz libmaxminddb ncurses libpng postgresql readline sqlite openssl libtool libwebp libxml++ libxslt libyaml make patch unzip xz-utils zlib perl \
	zip bash-completion htop jq less man-db nano sudo time vim multitail lsof \
&&	locale-gen en_US.UTF-8
&&	for pkgbuilds in libcurl-openssl-1.0 libmysqlclient-dev; do makepkg -si $pkgbuilds; done \
&&	yes | pacman -Sccccv

ENV LANG=en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc
### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir /home/gitpod/.bashrc.d && \
    (echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc
	
	
USER gitpod

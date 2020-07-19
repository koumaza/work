FROM archlinux

## Inital Upgrade and Install First Packages
RUN	pacman-key --init && pacman-key --populate \
&&	yes '' | \
	pacman -Syyv --needed --noconfirm archlinux-keyring \
&&	yes '' | \
	pacman -Syuuv --needed --noconfirm \
		base ca-certificates curl gnupg \
		breezy git mercurial openssh subversion procps-ng \
		base-devel \
		autoconf automake bzip2 pacman-contrib file gcc imagemagick glibc db libevent libffi gdbm tdb glib2 gmp-ecm libjpeg-turbo pam-krb5 xz libmaxminddb ncurses libpng postgresql readline sqlite openssl libtool libwebp libxml++ libxslt libyaml make patch unzip zlib perl \
		zip bash-completion htop jq less man-db nano sudo time vim multitail lsof \
&&	locale-gen en_US.UTF-8 \
#&&	sed -i.bak -e '/E_ROOT/d' /usr/bin/makepkg && for pkgbuilds in libcurl-openssl-1.0 libmysqlclient-dev; do git clone --depth=1 --single-branch https://aur.archlinux.org/${pkgbuilds}.git&& cd $pkgbuilds && yes|makepkg -si $pkgbuilds; done \
&&	yes | pacman -Sccccv

RUN	curl -Ls https://gist.github.com/koumaza/c65e8e9e0d7aacdbdc8d14cb893b7433/raw/fdcb34c13d287caa6df4574b623fc183deec362c/os-release_focal.txt > /etc/os-release

ENV	LANG=en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN	useradd -l -u 33333 -md /home/gitpod -s /bin/bash -p gitpod gitpod \
	# passwordless sudo for users in the 'sudo' group
	&& echo 'gitpod ALL=NOPASSWD:ALL' >> /etc/sudoers
ENV	HOME=/home/gitpod
WORKDIR	$HOME
# custom Bash prompt
RUN	{ echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc
### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN	sudo echo "Running 'sudo' for Gitpod: success" && \
	# create .bashrc.d folder and source it in the bashrc
	mkdir /home/gitpod/.bashrc.d && \
	(echo; echo "for i in \$(ls \$HOME/.bashrc.d/*); do source \$i; done"; echo) >> /home/gitpod/.bashrc
	
	
USER gitpod

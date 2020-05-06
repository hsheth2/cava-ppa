FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
	sudo \
	dh-make bzr-builddeb \
	gnupg ubuntu-dev-tools apt-file \
	pbuilder debootstrap devscripts \
	expect

RUN useradd -ms /bin/bash build && \
	sudo adduser build sudo && \
	echo 'build:build' | chpasswd
RUN mkdir /deploy && chown -R build /deploy
WORKDIR /deploy
USER build

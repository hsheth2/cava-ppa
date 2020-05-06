FROM ubuntu:xenial

RUN apt-get update && apt-get install -y \
	sudo \
	dh-make bzr-builddeb \
	gnupg pbuilder ubuntu-dev-tools apt-file \
	expect

RUN useradd -ms /bin/bash build
RUN mkdir /deploy && chown -R build /deploy
WORKDIR /deploy
USER build

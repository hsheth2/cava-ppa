ARG DISTRIBUTION
ARG IMAGE=ubuntu:${DISTRIBUTION}
FROM ${IMAGE}

# .deb build requirements
RUN apt-get update && apt-get install -y \
	sudo \
	build-essential \
	dh-make \
	devscripts \
	quilt \
	gnupg \
	openssh-client

# cava requirements
RUN apt-get update && apt-get install -y \
	libfftw3-dev libasound2-dev libncursesw5-dev libpulse-dev libtool automake libiniparser-dev

RUN useradd -ms /bin/bash build && \
	sudo adduser build sudo && \
	echo 'build:build' | chpasswd
RUN mkdir /deploy && chown -R build /deploy
WORKDIR /deploy
USER build

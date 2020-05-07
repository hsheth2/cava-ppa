#!/bin/bash

set -e

apt-get update && apt-get install -y \
	sudo \
	pbuilder debootstrap devscripts \
	gnupg ubuntu-dev-tools apt-file


cd /deploy

pbuilder-dist $DISTRIBUTION create

bash  # interactive

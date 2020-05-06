#!/bin/bash

#set -x
set -e

VERSION=0.6.1-0
DISTRIBUTION=bionic

IMAGE_NAME=hsheth2/cava-ppa-builder
CONTAINER_NAME=cava-ppa

docker build -t $IMAGE_NAME .

# Keep container running https://stackoverflow.com/a/36872226
docker rm $CONTAINER_NAME 2>/dev/null || true
docker run \
	--rm \
	-it \
	--name $CONTAINER_NAME \
	-v `pwd`/scripts:/scripts \
	-v `pwd`/resources:/resources \
	-v `pwd`/cava:/cava \
	-e VERSION=$VERSION \
	-e DISTRIBUTION=$DISTRIBUTION \
	$IMAGE_NAME \
	/scripts/build.sh


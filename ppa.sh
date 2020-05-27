#!/bin/bash

#set -x
set -e

source ./env.sh

# The distro we want to build a package for.
DISTRIBUTION=$1

IMAGE_NAME=hsheth2/cava-ppa-builder:$DISTRIBUTION
echo "Creating builder image called $IMAGE_NAME"
docker image pull ubuntu:$DISTRIBUTION
docker build --build-arg DISTRIBUTION=$DISTRIBUTION -t $IMAGE_NAME .

DEPLOY_VOLUME=cava_deploy_$DISTRIBTION
echo "Creating deploy volume called $DEPLOY_VOLUME"
docker volume create --name $DEPLOY_VOLUME || true

# Keep container running https://stackoverflow.com/a/36872226
docker run \
	--rm \
	-it \
	-v `pwd`/scripts:/scripts \
	-v `pwd`/resources:/resources \
	-v `pwd`/secrets:/secrets \
	-v `pwd`/cava:/cava:ro \
	-v $DEPLOY_VOLUME:/deploy \
	-e VERSION=$VERSION \
	-e DEBIAN_REVISION=$DEBIAN_REVISION \
	-e DISTRIBUTION=$DISTRIBUTION \
	$IMAGE_NAME \
	/scripts/build.sh


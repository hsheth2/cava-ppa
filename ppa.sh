#!/bin/bash

#set -x
set -e

source ./env.sh

IMAGE_NAME=hsheth2/cava-ppa-builder
CONTAINER_NAME=cava-ppa-builder
DEPLOY_VOLUME=cava_deploy

docker build --build-arg DISTRIBUTION=$DISTRIBUTION -t $IMAGE_NAME:$DISTRIBUTION .

docker volume create --name $DEPLOY_VOLUME || true

# Keep container running https://stackoverflow.com/a/36872226
docker rm $CONTAINER_NAME 2>/dev/null || true
docker run \
	--rm \
	-it \
	--privileged \
	--name $CONTAINER_NAME \
	-v `pwd`/scripts:/scripts \
	-v `pwd`/resources:/resources \
	-v `pwd`/secrets:/secrets \
	-v `pwd`/cava:/cava:ro \
	-v $DEPLOY_VOLUME:/deploy \
	-e VERSION=$VERSION \
	-e DEBIAN_REVISION=$DEBIAN_REVISION \
	-e DISTRIBUTION=$DISTRIBUTION \
	$IMAGE_NAME:$DISTRIBUTION \
	/scripts/build.sh


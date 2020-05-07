#!/bin/bash

source ./env.sh

docker volume create --name $DEPLOY_VOLUME || true

docker run \
	--rm \
	-it \
	--privileged \
	-v $DEPLOY_VOLUME:/deploy \
	-v `pwd`/scripts:/scripts \
	-e VERSION=$VERSION \
	-e DISTRIBUTION=$DISTRIBUTION \
	ubuntu:$DISTRIBUTION \
	/scripts/pbuilder.sh

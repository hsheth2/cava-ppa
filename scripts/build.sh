#!/bin/bash

set -e

[ ! -z $VERSION ] || exit 1
[ ! -z $DISTRIBUTION ] || exit 1


export DEBFULLNAME="Harshal Sheth"
export DEBEMAIL="hsheth2@gmail.com"
bzr whoami "Harshal Sheth <hsheth2@gmail.com>"

mkdir cava
cd cava

tar czf cava.tar.gz /cava

expect -c "spawn bzr dh-make cava $VERSION cava.tar.gz
expect -re \"Type of package:\"
send \"s\"
expect -re \"Are the details correct?\"
send \"y\"
expect eof"

cd cava
rm debian/*.ex debian/*.EX

cp /resources/control debian/
cp /resources/copyright debian/
cp /resources/changelog debian/
cp /resources/rules debian/
sed -i -e "s/{version}/$VERSION/g" debian/changelog
sed -i -e "s/{date}/`date +'%a, %d %b %Y %H:%M:%S +0000'`/g" debian/changelog
sed -i -e "s/{distribution}/$DISTRIBUTION/g" debian/changelog
cp README.md debian/README.source

bash

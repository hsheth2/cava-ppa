#!/bin/bash

set -e
rm -r /deploy/* || true

[ ! -z $VERSION ] || exit 1
[ ! -z $DISTRIBUTION ] || exit 1

export DEBFULLNAME="Harshal Sheth"
export DEBEMAIL="hsheth2@gmail.com"
bzr whoami "Harshal Sheth <hsheth2@gmail.com>"

eval "$(ssh-agent -s)"
chmod 600 /secrets/launchpad_id_rsa
ssh-add /secrets/launchpad_id_rsa

gpg --import /secrets/launchpad_key.asc

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

bzr builddeb -S
cd ..

cat <<EOF
[optional] Run the following command in the tester.sh container:

    cd cava/build-area && pbuilder-dist $DISTRIBUTION build cava_${VERSION}-1.dsc

Run the following commands to finish uploading:

    (cd cava && bzr push lp:~hsheth2/+junk/cava-package)
    dput ppa:hsheth2/ppa cava_${VERSION}-1_source.changes

EOF

bash  # interactive

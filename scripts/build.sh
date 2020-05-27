#!/bin/bash

set -e
rm -rf /deploy/* || true

[ ! -z $VERSION ] || exit 1
[ ! -z $DEBIAN_REVISION ] || exit 1
[ ! -z $DISTRIBUTION ] || exit 1

export DEBIAN_VERSION=${VERSION}-${DEBIAN_REVISION}

export DEBFULLNAME="Harshal Sheth"
export DEBEMAIL="hsheth2@gmail.com"

eval "$(ssh-agent -s)"
chmod 600 /secrets/launchpad_id_rsa
ssh-add /secrets/launchpad_id_rsa

gpg --import /secrets/launchpad_key.asc

mkdir cava
cd cava

tar czf cava_${VERSION}.orig.tar.gz /cava
cp -r /cava .

cd cava

# Setup debian directory.
mkdir debian/
cp /resources/control debian/
cp /resources/copyright debian/
cp /resources/changelog debian/
cp /resources/rules debian/
cp /resources/cava-docs.docs debian/
cp /resources/compat debian/
cp -r /resources/source debian/
sed -i -e "s/{version}/$DEBIAN_VERSION/g" debian/changelog
sed -i -e "s/{date}/`date +'%a, %d %b %Y %H:%M:%S +0000'`/g" debian/changelog
sed -i -e "s/{distribution}/$DISTRIBUTION/g" debian/changelog
cp README.md debian/README.source
chmod +x debian/rules

# Build source package.
debuild -sa -S

# Test building binary package locally.
debuild -sa -b

# Print upload instructions.
cd ..
cat <<EOF

Run the following commands to finish uploading:

    dput ppa:hsheth2/ppa cava_${DEBIAN_VERSION}_source.changes

EOF

bash  # interactive

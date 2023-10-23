#!/usr/bin/env bash

set -eoux pipefail

read -p "Enter a version number: " VERSION

INSTALL_DIR="planet-ix.co.uk-v${VERSION}"

echo "Creating new dir ${INSTALL_DIR}..."
mkdir -p ${INSTALL_DIR}

cd ${INSTALL_DIR}

tar xfvz ../planet-ix-site.tgz

cd ..

# f to force the overwrite
# h to not follow symbolic links needed in order to force replace of an existing link

if [[ `uname` == "Linux" ]]; then
    cd ../.. && ln -sfn deploy/planet-ix/${INSTALL_DIR} public_html && cd -
else
    cd ../.. && ln -sfh deploy/planet-ix/${INSTALL_DIR} public_html && cd -
fi

echo "Completed upgrade to ${VERSION}. Site should be available."
ls -lart ../../public_html

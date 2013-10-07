#!/bin/sh

INSTALL="/usr/local/keydist-temp"
SOURCE="/usr/local/keyutility/1.0"

if [ -d ${INSTALL} ]; then
    rm -rf ${INSTALL}
fi

mkdir ${INSTALL}
ln -s ${SOURCE}/bin/* ${INSTALL} 

if [ ! -h /etc/sshfs_default_sites.cfg ]; then
    ln -s ${SOURCE}/bin/sshfs_default_sites.cfg /etc
fi

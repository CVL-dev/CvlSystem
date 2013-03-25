#!/bin/sh

BIN="/usr/local/bin"
chown 755 ${BIN}/cvlbuild ${BIN}/cvlcreate

SOURCE="/usr/local/src"
BUILD_LIST="CvlBuildList.txt"
if [ -d ${SOURCE} ]; then
    if [ ! -f ${SOURCE}/${BUILD_LIST} ]; then
        cp -f ${BIN}/${BUILD_LIST} ${SOURCE}
    fi
fi

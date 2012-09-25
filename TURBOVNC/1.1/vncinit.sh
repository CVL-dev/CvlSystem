#!/bin/sh

# Wait 2 seconds to settle down.
sleep 2

MODULE=`echo $MODULEPATH`
if [ -z "${MODULE}" ]; then
    source /etc/profile.d/modules.sh
fi

module load turbovnc

CONFIG_PREFIX=`which vncserver | sed "s/\/bin\/vncserver//g"`
CONFIG_LIB="${CONFIG_PREFIX}/config"

# Check XFCE
XFCE=`cat /etc/X11/xinit/Xclients | grep XFCE`
if [ -z "${XFCE}" ]; then
    cp -f ${CONFIG_LIB}/Xclients /etc/X11/xinit
fi

cp -f ${CONFIG_LIB}/xfce-applications.menu /etc/xdg/menus
cp -f ${CONFIG_LIB}/cvl_desktop.svg /usr/share/xfce4/backdrops 

# Fixed hostname
HOSTNAME=`hostname`
INCLUDE_HOSTNAME=`cat /etc/hosts | grep ${HOSTNAME}`
if [ -z "${INCLUDE_HOSTNAME}" ]; then
    echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
fi

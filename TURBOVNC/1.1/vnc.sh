#!/bin/sh

ARG0=`basename $0`
Geometry="1440x900"
Depth="24"
Display="1"

module load libjpeg-turbo
module load turbovnc

function Usage()
{
    echo "Usage: "
    echo "${ARG0} - Start VNC session using default configuration."
    echo "${ARG0} --geometry geometry_value --display display_number - Start VNC session using user configuration"
    echo "${ARG0} stop - Stop VNC session"
}

function Stop()
{
    vncserver -kill :${Display}
}

function Start()
{
    Stop
    sleep 1
    vncserver -geometry ${Geometry} -depth ${Depth} :${Display}
}

function Initialisation()
{
    if [ ! -d ${HOME}/.config/xfce4 ]; then
        mkdir -p ${HOME}/.config/xfce4
    fi

    CONFIG_PREFIX=`which vncserver | sed "s/\/bin\/vncserver//g"`
    CONFIG_LIB="${CONFIG_PREFIX}/config"

    if [ ! -d ${HOME}/.config/xfce4/xfconf ]; then
        cp -r ${CONFIG_LIB}/xfconf ${HOME}/.config/xfce4 
    fi
}

while [ $# -ge 1 ]; do
    case "$1" in
        -d|--display)
            Display=$2
            ;;
        -g|--geometry)
            Geometry=$2
            ;;
        -h|--help)
            Usage
            exit 0
            ;;
        -s|stop)
            Stop
            exit 0
            ;;
    esac
    shift
done

Initialisation
Start

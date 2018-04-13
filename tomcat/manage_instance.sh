#!/bin/env bash

CURR_DIR=`dirname $BASH_SOURCE`

export CATALINA_HOME=/opt/apache-tomcat
export CATALINA_BASE=`readlink -f ${CURR_DIR}`

function startup() {
    if [ -f ${CATALINA_HOME}/bin/startup.sh ]
    then
        ${CATALINA_HOME}/bin/startup.sh
    else
        echo "startup.sh not found"
    fi
}

function shutdown() {
    if [ -f ${CATALINA_HOME}/bin/shutdown.sh ]
    then
        ${CATALINA_HOME}/bin/shutdown.sh
    else
        echo "shutdown.sh not found"
    fi
}

case ${1} in
    start)
        startup
        ;;
    stop)
        shutdown
        ;;
    restart)
        shutdown
        startup
        ;;
    *)
        echo "USAGE: ${0} { start | stop | restart }"
        ;;
esac

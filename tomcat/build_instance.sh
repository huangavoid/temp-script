#!/bin/env bash

CURR_DIR=`dirname ${BASH_SOURCE}`
CATALINA_HOME=/opt/apache-tomcat
APP_DIR=/srv/java-webapps

for i in {1..3}
do
    INST_DIR=${CURR_DIR}/tomcat-${i}
    mkdir -p ${INST_DIR}/{conf,logs,work,temp}
    cp -a ${CATALINA_HOME}/conf/* ${INST_DIR}/conf
    sed -i  "22s@8005@8${i}05@" ${INST_DIR}/conf/server.xml
    sed -i  "69s@8080@8${i}80@" ${INST_DIR}/conf/server.xml
    sed -i "116s@8009@8${i}09@" ${INST_DIR}/conf/server.xml
    sed -i "148s@appBase=\"webapps\"@appBase=\"${APP_DIR}\"@" ${INST_DIR}/conf/server.xml
done

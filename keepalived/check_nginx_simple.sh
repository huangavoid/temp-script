#!/bin/env bash

counter=$(ps -C nginx --no-heading | wc -l)
if [ ${counter} ]
then
    service nginx start
    sleep 2
    
    counter=$(ps -C nginx --no-heading | wc -l)
    if [ ${counter} ]
    then
        service keepalived stop
    fi
fi

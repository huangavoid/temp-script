#!/bin/env bash
#
# curl --connect-timeout 3 -sL -w "%{http_code}\\n" -o /dev/null http://localhost


count=0

for k in {1..2}
do
    check_code=$( curl --connect-timeout 3 -sL -w "%{http_code}\\n" -o /dev/null http://localhost )
    if [ ${check_code} -eq 200 ]
    then
        count=$( expr ${count} + 1 )
        sleep 3
        continue
    else
        count=0
        break
    fi
done

if [ ${count} -eq 0 ]
then
    service keepalived stop
    exit 1
else
    exit 0
fi

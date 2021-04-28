#!/usr/bin/env bash

set +x
set -o nounset
set -o errexit
set -o pipefail

cd `dirname $0`/..

PID_FILE="logs/app.pid"

if [ -f ${PID_FILE} -a -e /proc/$(cat ${PID_FILE}) ]; then
    kill $(cat ${PID_FILE})
    sleep 1
    rm -f $PID_FILE
fi

#!/bin/bash

set +x
set -o nounset
set -o errexit
set -o pipefail

cd $(dirname $0)/..

PID_FILE="logs/app.pid"
CONSUL_CONF="conf/consul_auth"

[ -f ${CONSUL_CONF} ] && source ${CONSUL_CONF} || \
    { echo -e "\033[31mFailed, Not found ${CONSUL_CONF}\033[0m"; exit 1; }

type java >/dev/null 2>&1 || { echo -e "\033[31mFailed, Not found java\033[0m"; exit 1; }

if [ -f ${PID_FILE} -a -e /proc/$(cat ${PID_FILE}) ]; then
    kill $(cat ${PID_FILE})
    sleep 1
    rm -f $PID_FILE
fi

nohup java -cp \
    conf:lib/* \
    -server -XX:+UseG1GC -Xmx2048M \
    -Dconfig.file=$(realpath conf/application.conf) \
    -Dfile.encoding=UTF-8 \
    -Ddryad.consul.host=${CONSUL_HOST} \
    -Ddryad.consul.port=${CONSUL_PORT} \
    -Ddryad.consul.username=${CONSUL_USERNAME} \
    -Ddryad.consul.password=${CONSUL_PASSWORD} \
    io.growing.UndertowBootstrap > logs/start.log 2>&1 &
echo $! > logs/app.pid

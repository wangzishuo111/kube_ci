#!/bin/bash

set -xe

version=${SERVICE_VERSION}
docker_repository="registry.growingio.com:5000"
app="charts-service"
new_images="$docker_repository/$app:$version"

cd ../

sbt -no-colors packAgent
[ -d kubernetes/app ] && rm -rf kubernetes/app
mkdir -p kubernetes/app/logs
cp -r target/pack/{bin,lib} kubernetes/app/
cd kubernetes

docker build -t $new_images .
docker push $new_images
docker rmi $new_images

#!/bin/bash

mkdir -p output

echo Switching to Docker for Mac
eval $(docker-machine env -unset)
echo Building Linux image with tar and nanoserver
docker build -t prepnano .
echo Shrinking nanoserver
docker run -v $(pwd):/work prepnano /work/shrink.sh /work/output/shrinknano.tar.gz

echo Switching to Windows
eval $(docker-machine env insider)
echo Importing shrinknano206
docker import output/shrinknano.tar.gz stefanscherer/shrinknano
docker images

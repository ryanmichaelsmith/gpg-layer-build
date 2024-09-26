#!/bin/sh

docker build . -t gpg-layer:latest
docker run --name gpg-layer-export gpg-layer:latest
docker cp gpg-layer-export:/var/task/gpg-layer.zip .
docker rm gpg-layer-export
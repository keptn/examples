#!/bin/bash

# Build loadgenerator
docker build . -t keptnexamples/cartsloadgenerator:0.1

# we push the image into the cluster repository
docker push keptnexamples/cartsloadgenerator:0.1


#!/bin/bash

cd ../manifests/backend-services/user-db
oc apply -f dev/
oc apply -f staging/
oc apply -f production/

cd ../shipping-rabbitmq
oc apply -f dev/
oc apply -f staging/
oc apply -f production/



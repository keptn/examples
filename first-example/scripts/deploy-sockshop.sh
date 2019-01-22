#!/bin/bash

cd ../manifests/backend-services/user-db
kubectl apply -f dev/
kubectl apply -f staging/
kubectl apply -f production/

cd ../shipping-rabbitmq
kubectl apply -f dev/
kubectl apply -f staging/
kubectl apply -f production/

cd ../carts-db
kubectl apply -f carts-db.yml

cd ../catalogue-db
kubectl apply -f catalogue-db.yml

cd ../orders-db
kubectl apply -f orders-db.yml

cd ../../sockshop-app
kubectl apply -f dev/
kubectl apply -f staging/
kubectl apply -f production/



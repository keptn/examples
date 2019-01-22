#!/bin/bash

cd ../repositories/sockshop-infrastructure
kubectl apply -f carts-db.yml
kubectl apply -f catalogue-db.yml
kubectl apply -f orders-db.yml
kubectl apply -f rabbitmq.yaml
kubectl apply -f user-db.yaml

# Apply services
declare -a repositories=("carts" "catalogue" "front-end" "orders" "payment" "queue-master" "shipping" "user")

for repo in "${repositories[@]}"
do
    cd ../carts/manifest
    kubectl apply -f .
    # sed
    kubectl apply -f .
    # sed
    kubectl apply -f .
    # sed
done
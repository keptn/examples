#!/bin/sh

kubectl apply -f namespace.yaml
kubectl apply -f config-map.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f prometheus.yaml

#!/bin/sh
kubectl delete -f config-map.yaml --ignore-not-found
kubectl delete -f cluster-role.yaml --ignore-not-found
kubectl delete -f prometheus.yaml --ignore-not-found
kubectl delete -f namespace.yaml --ignore-not-found
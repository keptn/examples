#!/bin/sh
kubectl delete -f config-map.yaml --ignore-not-found
kubectl delete -f cluster-role.yaml --ignore-not-found
kubectl delete -f prometheus.yaml --ignore-not-found
kubectl delete -f alertmanager-configmap.yaml --ignore-not-found
kubectl delete -f alertmanager-template.yaml --ignore-not-found
kubectl delete -f alertmanager-deployment.yaml --ignore-not-found
kubectl delete -f alertmanager-svc.yaml --ignore-not-found

kubectl delete -f namespace.yaml --ignore-not-found
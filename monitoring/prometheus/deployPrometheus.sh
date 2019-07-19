#!/bin/sh

export GATEWAY=$(kubectl get configmap -n keptn keptn-domain -oyaml -ojsonpath="{.data.app_domain}")

rm -f gen/config-map.yaml

cat config-map.yaml | \
  sed 's~GATEWAY_PLACEHOLDER~'"$GATEWAY"'~g' >> gen/config-map.yaml

kubectl apply -f namespace.yaml
kubectl apply -f gen/config-map.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f prometheus.yaml

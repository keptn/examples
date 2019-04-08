#!/bin/sh

export GATEWAY=$(kubectl describe svc istio-ingressgateway -n istio-system | grep "LoadBalancer Ingress:" | sed 's~LoadBalancer Ingress:[ \t]*~~')

GATEWAY="$GATEWAY.xip.io"

rm -f gen/config-map.yaml

cat config-map.yaml | \
  sed 's~GATEWAY_PLACEHOLDER~'"$GATEWAY"'~g' >> gen/config-map.yaml

kubectl apply -f namespace.yaml
kubectl apply -f gen/config-map.yaml
kubectl apply -f cluster-role.yaml
kubectl apply -f prometheus.yaml

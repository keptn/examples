#!/bin/bash
set -e

echo "Configure Istio and Keptn"

# Get Ingress gateway IP-Address
export INGRESS_IP=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Check if IP-Address is not empty or pending
if [ -z "$INGRESS_IP" ] || [ "$INGRESS_IP" = "Pending" ] ; then
 	echo "INGRESS_IP is empty. Make sure that the Ingress gateway is ready"
	exit 1
fi

# Applying ingress-manifest
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: istio
  name: api-keptn-ingress
  namespace: keptn
spec:
  rules:
  - host: $INGRESS_IP.nip.io
    http:
      paths:
      - backend:
          serviceName: api-gateway-nginx
          servicePort: 80
EOF

# Applying public gateway
kubectl apply -f - <<EOF
---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: public-gateway
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      name: http
      number: 80
      protocol: HTTP
    hosts:
    - '*'
EOF

echo "Waiting a little bit"
sleep 10

# Creating Keptn ingress config map
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}') --from-literal=ingress_port=80 --from-literal=ingress_protocol=http --from-literal=istio_gateway=public-gateway.istio-system -oyaml --dry-run | kubectl apply -f -

# Restart helm service
kubectl delete pod -n keptn -lapp.kubernetes.io/name=helm-service
#!/bin/bash
set -e

echo "Configure Istio and Keptn"

# Get Ingress gateway IP-Address
export INGRESS_IP=$(kubectl -n istio-system get svc istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Check if IP-Address is not empty or pending
if [ -z "$INGRESS_IP" ] || [ "$INGRESS_IP" = "Pending" ] ; then
 	echo "Could not determine the external IP address of istio-ingressgateway in namespace istio-system. Please make sure it is ready and has an external IP address:"
 	echo " - kubectl -n istio-system get svc istio-ingressgateway"
 	echo ""
 	echo "Please consult the istio docs for more information: https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/#determining-the-ingress-ip-and-ports"
	exit 1
fi

echo "External IP for istio-ingressgateway is ${INGRESS_IP}, creating configmaps..."

# Applying ingress-manifest
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
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
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-gateway-nginx
            port:
              number: 80
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
kubectl create configmap -n keptn ingress-config --from-literal=ingress_hostname_suffix=$(kubectl -n keptn get ingress api-keptn-ingress -ojsonpath='{.spec.rules[0].host}') --from-literal=ingress_port=80 --from-literal=ingress_protocol=http --from-literal=istio_gateway=public-gateway.istio-system -oyaml --dry-run=client | kubectl apply -f -

echo "Restarting helm-service..."

# Restart helm service
kubectl delete pod -n keptn -lapp.kubernetes.io/name=helm-service

echo "Done!"

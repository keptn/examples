#!/bin/bash

if [ -z "$DT_TENANT" ]; then
 	echo "Please supply a value for the environment variable DT_TENANT"
	exit 1
fi

if [ -z "$DT_API_TOKEN" ]; then
 	echo "Please supply a value for the environment variable DT_API_TOKEN"
	exit 1
fi

if [ -z "$DT_PAAS_TOKEN" ]; then
 	echo "Please supply a value for the environment variable DT_PAAS_TOKEN"
	exit 1
fi

function replace_value_in_yaml_file() {
  OLDVAL=$1; NEWVAL=$2; FILE=$3

  sed -i "s#$OLDVAL#$NEWVAL#g" $FILE
}

function wait_for_deployment_in_namespace() {
  DEPLOYMENT=$1; NAMESPACE=$2;
  RETRY=0; RETRY_MAX=50;

  while [[ $RETRY -lt $RETRY_MAX ]]; do
    DEPLOYMENT_LIST=$(eval "kubectl get deployments -n ${NAMESPACE} | awk '/$DEPLOYMENT /'" | awk '{print $1}') # list of multiple deployments when starting with the same name
    if [[ -z "$DEPLOYMENT_LIST" ]]; then
      RETRY=$[$RETRY+1]
      echo "Retry: ${RETRY}/${RETRY_MAX} - Wait 10s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
      sleep 15
    else
      READY_REPLICAS=$(eval kubectl get deployments $DEPLOYMENT -n $NAMESPACE -o=jsonpath='{$.status.availableReplicas}')
      WANTED_REPLICAS=$(eval kubectl get deployments $DEPLOYMENT  -n $NAMESPACE -o=jsonpath='{$.spec.replicas}')
      if [[ "$READY_REPLICAS" = "$WANTED_REPLICAS" ]]; then
        echo "Found deployment ${DEPLOYMENT} in namespace ${NAMESPACE}: ${DEPLOYMENT_LIST}"
        break
      else
          RETRY=$[$RETRY+1]
          echo "Retry: ${RETRY}/${RETRY_MAX} - Wait 15s for deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
          sleep 15
      fi
    fi
  done

  if [[ $RETRY == $RETRY_MAX ]]; then
    echo "Error: Could not find deployment ${DEPLOYMENT} in namespace ${NAMESPACE}"
    exit 1
  fi
}

kubectl create namespace dynatrace
sleep 5

kubectl apply -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml

echo "Waiting a little bit before we continue..."
sleep 10
echo "Continuing now!"

kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken=$DT_API_TOKEN" --from-literal="paasToken=$DT_PAAS_TOKEN"

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/cr.yaml

URL=https://ENVIRONMENTID.live.dynatrace.com/api
API_URL=https://${DT_TENANT}/api
replace_value_in_yaml_file $URL $API_URL cr.yaml

kubectl apply -f cr.yaml

echo "Verifying Dynatrace oneagent installation"
wait_for_deployment_in_namespace "dynatrace-oneagent-operator" "dynatrace"
wait_for_deployment_in_namespace "dynatrace-oneagent-webhook" "dynatrace"

rm cr.yaml
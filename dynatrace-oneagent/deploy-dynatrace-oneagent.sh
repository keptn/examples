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

kubectl create namespace dynatrace
sleep 10

kubectl apply -f https://github.com/Dynatrace/dynatrace-oneagent-operator/releases/latest/download/kubernetes.yaml

echo "Waiting a little bit before we continue..."
sleep 30
echo "Continuing now!"

kubectl -n dynatrace create secret generic oneagent --from-literal="apiToken=$DT_API_TOKEN" --from-literal="paasToken=$DT_PAAS_TOKEN"

curl -o cr.yaml https://raw.githubusercontent.com/Dynatrace/dynatrace-oneagent-operator/master/deploy/cr.yaml

export URL=$(echo https://ENVIRONMENTID.live.dynatrace.com/api)
export API_URL=$(echo https://${DT_TENANT}/api)
replace_value_in_yaml_file $URL $API_URL cr.yaml

kubectl apply -f cr.yaml

echo "Waiting a little bit before we continue..."
sleep 20
echo "Continuing now!"

rm cr.yaml
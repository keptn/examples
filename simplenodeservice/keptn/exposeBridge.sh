#!/bin/bash

echo ""
echo "STARTING WITH KEPTN 0.7 THIS IS NO LONGER RELEVANT!!!"
echo "With Keptn 0.7 simply use 'keptn configure bridge'"
echo ""
echo ""
echo "Continue for Keptn 0.6.x!"
echo "============================================================="
echo "About to create a VirtualService to the Keptn Bridge service"
echo "============================================================="
read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key
echo ""

DOMAIN=$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})

rm -f ./manifests/gen/bridge.yaml
cat ./manifests/bridge.yaml | \
  sed 's~DOMAIN_PLACEHOLDER~'"$DOMAIN"'~' > ./manifests/gen/bridge.yaml

kubectl apply -f ./manifests/gen/bridge.yaml

echo "Bridge URL: https://bridge.keptn.$DOMAIN"
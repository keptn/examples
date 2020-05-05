#!/bin/bash

if [[ -z "$KEPTN_PROJECT" ]]; then
  KEPTN_PROJECT=$1
fi
if [[ -z "$KEPTN_STAGE" ]]; then
  KEPTN_STAGE=$2
fi
if [[ -z "$KEPTN_SERVICE" ]]; then
  KEPTN_SERVICE=$3
fi

if [[ -z "$SLI_VERSION" ]]; then
  SLI_VERSION="basic"
fi

if [[ -z "$KEPTN_PROJECT" || -z "$KEPTN_STAGE" || -z "$KEPTN_SERVICE" ]]; then
  echo "You have to either set KEPTN_PROJECT, KEPTN_STAGE & KEPTN_SERVICE or pass them as arguments"
  echo "usage: ./add_resources.sh simplenodeproject staging simplenode [basic|perftest]"
  exit 1
fi

echo "Lets upload all relevant resource files to Keptn, e.g: SLI, SLO, jmeter, ..."

# adding resources
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=jmeter/jmeter.conf.yaml --resourceUri=jmeter/jmeter.conf.yaml
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=dynatrace/dynatrace.conf.yaml --resourceUri=dynatrace/dynatrace.conf.yaml
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=dynatrace/sli_$SLI_VERSION.yaml --resourceUri=dynatrace/sli.yaml
keptn add-resource --project=$PROJECT --service=$SERVICE --stage=$STAGE --resource=slo_$SLI_VERSION.yaml --resourceUri=slo.yaml

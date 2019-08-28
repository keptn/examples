#!/bin/sh

if [ -z $1 ]
then
  echo "Please provide the name of your project."
  echo ""
  echo "Usage: ./deployPrometheus.sh projectname servicename shipard.yaml"
  exit 1
fi

if [ -z $2 ]
then
echo "Please provide the name of your service."
  echo ""
  echo "Usage: ./deployPrometheus.sh projectname servicename shipard.yaml"
  exit 1
fi

if [ -z $3 ]
then
echo "Please provide the shipyard file of your project."
  echo ""
  echo "Usage: ./deployPrometheus.sh projectname servicename shipard.yaml"
  exit 1
fi


export PROJECTNAME=$1
export SERVICENAME=$2
export GATEWAY=$(kubectl get configmap -n keptn keptn-domain -oyaml -ojsonpath="{.data.app_domain}")


rm -f gen/scrape_jobs.yaml

STAGES=$(cat shipyard.yaml | grep "name:" | cut -d '"' -f2)

for word in $STAGES ; do
  cat scrape_jobs_template.yaml | \
  sed 's~GATEWAY_PLACEHOLDER~'"$GATEWAY"'~g' >> gen/scrape_jobs.yaml

  sed -i '' 's~SERVICENAME_PLACEHOLDER~'"$SERVICENAME"'~g' gen/scrape_jobs.yaml
  sed -i '' 's~PROJECTNAME_PLACEHOLDER~'"$PROJECTNAME"'~g' gen/scrape_jobs.yaml
  sed -i '' 's~STAGE_PLACEHOLDER~'"$word"'~g' gen/scrape_jobs.yaml
done

rm gen/config-map.yaml

cp config-map.yaml gen/config-map.yaml
cat gen/scrape_jobs.yaml >> gen/config-map.yaml

# insert prometheus rules into config-map
rm -f gen/prometheus-rules.yaml
cp prometheus-rules.yaml gen/prometheus-rules.yaml
sed -i '' 's~SERVICENAME_PLACEHOLDER~'"$SERVICENAME"'~g' gen/prometheus-rules.yaml
sed -i '' 's~PROJECTNAME_PLACEHOLDER~'"$PROJECTNAME"'~g' gen/prometheus-rules.yaml
awk '/###RULES_PLACEHOLDER###/{system("cat gen/prometheus-rules.yaml");next}1' gen/config-map.yaml > gen/config-map.tmp
mv gen/config-map.tmp gen/config-map.yaml

kubectl apply -f gen/config-map.yaml
kubectl delete pod --all -n monitoring

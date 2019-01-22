#!/bin/bash

entries=$(curl https://$1.live.dynatrace.com/api/v1/deployment/installer/agent/connectioninfo?Api-Token=$2 | jq -r '.communicationEndpoints[]')

mkdir se_tmp
touch se_tmp/hosts
touch se_tmp/service_entries_oneagent.yml
touch se_tmp/service_entries

cat ../manifests/istio/service_entries_tpl/part1 >> se_tmp/service_entries_oneagent.yml

echo -e "  - $1.live.dynatrace.com" >> se_tmp/hosts
cat ../manifests/istio/service_entry_tmpl | sed 's~ENDPOINT_PLACEHOLDER~'"$1"'.live.dynatrace.com~' >> se_tmp/service_entries

for row in $entries; do
    row=$(echo $row | sed 's~https://~~')
    row=$(echo $row | sed 's~/communication~~')
    echo -e "  - $row" >> se_tmp/hosts
    cat ../manifests/istio/service_entry_tmpl | sed 's~ENDPOINT_PLACEHOLDER~'"$row"'~' >> se_tmp/service_entries
done

cat se_tmp/hosts >> se_tmp/service_entries_oneagent.yml
cat ../manifests/istio/service_entries_tpl/part2 >> se_tmp/service_entries_oneagent.yml
cat se_tmp/hosts >> se_tmp/service_entries_oneagent.yml
cat ../manifests/istio/service_entries_tpl/part3 >> se_tmp/service_entries_oneagent.yml
cat se_tmp/service_entries >> se_tmp/service_entries_oneagent.yml

kubectl apply -f se_tmp/service_entries_oneagent.yml

rm -rf se_tmp
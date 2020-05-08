#!/bin/bash

# Usage:
# ./createTestRequestAttributes.sh

if [[ -z "$DT_TENANT" || -z "$DT_API_TOKEN" ]]; then
  echo "DT_TENANT & DT_API_TOKEN MUST BE SET!!"
  exit 1
fi

echo "============================================================="
echo "About to create 3 Request Attributes (LTN, LSN, LTN) for better Test Integrations on Dynatrace Tenant: $DT_TENANT!"
echo "If these Request Attributes already exists they WONT be overwritten!"
echo "For more information about Load Testing Integration with Dynatrace check out the doc!"
echo "============================================================="
echo "Usage: ./createTestRequestAttributes"
read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

####################################################################################################################
## createRequestAttribute(ATTRIBUTENAME, ATTRIBUTEPREFIX, HEADERNAME)
####################################################################################################################
# Example: createRequestAttribute "TSN", "TSN", "x-dynatrace-test")
function createRequestAttribute() {
    ATTRIBUTENAME=$1
    ATTRIBUTEPREFIX=$2
    HEADERNAME=$3
    PAYLOAD='{
        "name": "'$ATTRIBUTENAME'",
        "enabled": true,
        "dataType": "STRING",
        "dataSources": [
            {
            "enabled": true,
            "source": "REQUEST_HEADER",
            "valueProcessing": {
                "splitAt": "",
                "trim": false,
                "extractSubstring": {
                "position": "BETWEEN",
                "delimiter": "'$ATTRIBUTEPREFIX'=",
                "endDelimiter": ";"
                }
            },
            "parameterName": "'$HEADERNAME'",
            "capturingAndStorageLocation": "CAPTURE_AND_STORE_ON_SERVER"
            }
        ],
        "normalization": "ORIGINAL",
        "aggregation": "FIRST",
        "confidential": false,
        "skipPersonalDataMasking": false
      }'

  echo ""
  echo "Creating Request Attribute $ATTRIBUTENAME. Parsing $ATTRIBUTEPREFIX=??; from $HEADERNAME)"
  echo "POST https://$DT_TENANT/api/config/v1/service/requestAttributes"
  echo "$PAYLOAD"
  curl -X POST \
          "https://$DT_TENANT/api/config/v1/service/requestAttributes" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d "$PAYLOAD" \
          -o curloutput.txt
  cat curloutput.txt
  echo ""
}


###########################################################################
# Create the 3 Request Attributes to parse out TSN (Test Step), LSN (Load Script Name), LTN (Load Test NAme)
###########################################################################
createRequestAttribute "TSN" "TSN" "x-dynatrace-test"
createRequestAttribute "LTN" "LTN" "x-dynatrace-test"
createRequestAttribute "LSN" "LSN" "x-dynatrace-test"

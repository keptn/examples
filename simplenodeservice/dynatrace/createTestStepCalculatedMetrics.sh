#!/bin/bash

# Usage:
# ./createTestStepCalculatedMetrics.sh CONTEXTLESS keptn_project simpleproject
if [[ -z "$DT_TENANT" || -z "$DT_API_TOKEN" ]]; then
  echo "DT_TENANT & DT_API_TOKEN MUST BE SET!!"
  exit 1
fi
CONDITION_CONTEXT=$1
CONDITION_KEY=$2
CONDITION_VALUE=$3

if [[ -z "$CONDITION_KEY" && -z "$CONDITION_VALUE" ]]; then
  echo "You have to at least specify a Tag Key or Value as a filter:"
  echo "Usage: ./createTestStepCalculatedMetrics.sh TAGCONTEXT TAGKEY [TAGVALUE]"
  echo "Example #1 for Keptn projects: ./createTestStepCalculatedMetrics.sh CONTEXTLESS keptn_project"
  echo "Example #2 for Env-Tags: ./createTestStepCalculatedMetrics.sh ENVIRONMENT AppUnderTest"
  exit 1
fi

echo "============================================================="
echo "About to create 6 calculated service metrics for Test Tool Integrations on Dynatrace Tenant: $DT_TENANT!"
echo "These metrics will filter on service tag [$1]$2:$3 and Request Attribute TSN exists"
echo "============================================================="
echo "Usage: ./createTestStepCalculatedMetrics CONTEXT KEY VALUE"
read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

####################################################################################################################
## createCalculatedTestMetric(METRICKEY, METRICNAME, BASEMETRIC, METRICUNIT, DIMENSION_NAME, DIMENSION_PATTERN, DIMENSION_AGGREGATE)
####################################################################################################################
# Example: createCalculatedTestMetric "calc:service.teststepresponsetime" "Test Step Response Time" "RESPONSE_TIME" "MICRO_SECOND" "Test Step" "{RequestAttribute:TSN}" "SUM"
# Full List of possible BASEMETRICS: CPU_TIME, DATABASE_CHILD_CALL_COUNT, DATABASE_CHILD_CALL_TIME, EXCEPTION_COUNT, FAILED_REQUEST_COUNT, FAILED_REQUEST_COUNT_CLIENT, FAILURE_RATE, FAILURE_RATE_CLIENT, HTTP_4XX_ERROR_COUNT, HTTP_4XX_ERROR_COUNT_CLIENT, HTTP_5XX_ERROR_COUNT, HTTP_5XX_ERROR_COUNT_CLIENT, IO_TIME, LOCK_TIME, NON_DATABASE_CHILD_CALL_COUNT, NON_DATABASE_CHILD_CALL_TIME, REQUEST_ATTRIBUTE, REQUEST_COUNT, RESPONSE_TIME, RESPONSE_TIME_CLIENT, SUCCESSFUL_REQUEST_COUNT, SUCCESSFUL_REQUEST_COUNT_CLIENT, TOTAL_PROCESSING_TIME, WAIT_TIME
# Possible METRICUNIT values: MILLI_SECOND, MICRO_SECOND, COUNT, PERCENT 
# Possible DIMENSION_AGGREGATE: AVERAGE, COUNT, MAX, MIN, OF_INTEREST_RATIO, OTHER_RATIO, SINGLE_VALUE, SUM
function createCalculatedTestMetric() {
    METRICKEY=$1
    METRICNAME=$2
    BASEMETRIC=$3
    METRICUNIT=$4
    DIMENSION_NAME=$5
    DIMENSION_PATTERN=$6
    DIMENSION_AGGREGATE=$7
    PAYLOAD='{
        "tsmMetricKey": "'$METRICKEY'",
        "name": "'$METRICNAME'",
        "enabled": true,
        "metricDefinition": {
            "metric": "'$BASEMETRIC'",
            "requestAttribute": null
        },
        "unit": "'$METRICUNIT'",
        "unitDisplayName": "",
        "conditions": [
            {
                "attribute": "SERVICE_REQUEST_ATTRIBUTE",
                "comparisonInfo": {
                    "type": "STRING_REQUEST_ATTRIBUTE",
                    "comparison": "EXISTS",
                    "value": null,
                    "negate": false,
                    "requestAttribute": "TSN",
                    "caseSensitive": false
                }
            },
            {
                "attribute": "SERVICE_TAG",
                "comparisonInfo": {
                    "type": "TAG",
                    "comparison": "TAG_KEY_EQUALS",
                    "value": {
                        "context": "'$CONDITION_CONTEXT'",
                        "key": "'$CONDITION_KEY'",
                        "value": "'$CONDITION_VALUE'"
                    },
                    "negate": false
                }
            }
        ],
        "dimensionDefinition": {
            "name": "'$DIMENSION_NAME'",
            "dimension": "'$DIMENSION_PATTERN'",
            "placeholders": [],
            "topX": 10,
            "topXDirection": "DESCENDING",
            "topXAggregation": "'$DIMENSION_AGGREGATE'"
        }
      }'

  echo ""
  echo "Creating Metric $METRICNAME($METRICNAME)"
  echo "PUT https://$DT_TENANT/api/config/v1/calculatedMetrics/service/$METRICKEY"
  echo "$PAYLOAD"
  curl -X PUT \
          "https://$DT_TENANT/api/config/v1/calculatedMetrics/service/$METRICKEY" \
          -H 'accept: application/json; charset=utf-8' \
          -H "Authorization: Api-Token $DT_API_TOKEN" \
          -H 'Content-Type: application/json; charset=utf-8' \
          -d "$PAYLOAD" \
          -o curloutput.txt
  cat curloutput.txt
  echo ""
}



###########################################################################
# 1: we create Test Step Response Time
###########################################################################
createCalculatedTestMetric "calc:service.teststepresponsetime" "Test Step Response Time" "RESPONSE_TIME" "MICRO_SECOND" "Test Step" "{RequestAttribute:TSN}" "SUM"

###########################################################################
# 2: we create Test Step Service Calls
###########################################################################
createCalculatedTestMetric "calc:service.teststepservicecalls" "Test Step Service Calls" "NON_DATABASE_CHILD_CALL_COUNT" "COUNT" "Test Step" "{RequestAttribute:TSN}" "SUM"

###########################################################################
# 3: we create Test Step Database Calls
###########################################################################
createCalculatedTestMetric "calc:service.teststepdbcalls" "Test Step DB Calls" "DATABASE_CHILD_CALL_COUNT" "COUNT" "Test Step" "{RequestAttribute:TSN}" "SUM"

###########################################################################
# 4: we create Test Step Failurerate
###########################################################################
createCalculatedTestMetric "calc:service.teststepfailurerate" "Test Step Failure Rate" "FAILURE_RATE" "PERCENT" "Test Step" "{RequestAttribute:TSN}" "OF_INTEREST_RATIO"

###########################################################################
# 5: we create Test Step by HTTP Status
###########################################################################
createCalculatedTestMetric "calc:service.testrequestsbyhttpstatus" "Test Requests by HTTP Status" "REQUEST_COUNT" "COUNT" "HttpStatusClass" "{HTTP-StatusClass}" "SINGLE_VALUE"

###########################################################################
# 6: we create Test Step CPU Time
###########################################################################
createCalculatedTestMetric "calc:service.teststepcpu" "Test Step CPU" "CPU_TIME" "MICRO_SECOND" "Test Step" "{RequestAttribute:TSN}" "SUM"

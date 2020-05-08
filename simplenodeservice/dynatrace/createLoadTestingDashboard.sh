#!/bin/bash

# Usage:
# ./createLoadTestingDashboard.sh DashboardName
if [[ -z "$DT_TENANT" || -z "$DT_API_TOKEN" ]]; then
  echo "DT_TENANT & DT_API_TOKEN MUST BE SET!!"
  exit 1
fi

KEPTN_DOMAIN=$(kubectl get cm keptn-domain -n keptn -ojsonpath={.data.app_domain})
if [[ -z "$KEPTN_DOMAIN" ]]; then
  echo "Couldn't retrieve keptn domain for your k8s cluster!"
  exit 1
fi

DASHBOARDNAME=$1
if [[ -z "$DASHBOARDNAME"  ]]; then
  DASHBOARDNAME="Keptn Performance As a Self-Service Insights Dashboard"
fi

# TODO: Query Synthetic Test & Web Application

echo "============================================================="
echo "About to create dashboard '$DASHBOARDNAME' "
echo "  on Dynatrace Tenant: $DT_TENANT for Keptn Domain $KEPTN_DOMAIN"
echo "============================================================="
read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

PAYLOAD='
{
"dashboardMetadata": {
    "name": "'$DASHBOARDNAME'",
    "shared": false,
    "owner": "",
    "sharingDetails": {
      "linkShared": true,
      "published": false
    },
    "dashboardFilter": {
      "timeframe": "",
      "managementZone": null
    }
  },
  "tiles": [
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 988,
        "width": 342,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Top CPU Consuming Test Step",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TOP_LIST",
          "series": [
            {
              "metric": "calc:service.teststepcpu",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 646,
        "width": 342,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Top Backend Service calls per Test Case",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TOP_LIST",
          "series": [
            {
              "metric": "calc:service.teststepservicecalls",
              "aggregation": "NONE",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 0,
        "width": 304,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Slowest Test Steps",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TOP_LIST",
          "series": [
            {
              "metric": "calc:service.teststepresponsetime",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 304,
        "width": 342,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Top Failing Test Steps",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TOP_LIST",
          "series": [
            {
              "metric": "calc:service.teststepfailurerate",
              "aggregation": "OF_INTEREST_RATIO",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 0,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "HTTP Response Codes",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "PIE",
          "series": [
            {
              "metric": "calc:service.testrequestsbyhttpstatus",
              "aggregation": "NONE",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "HttpStatusClass",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 304,
        "width": 684,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "HTTP Response Codes over time",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "calc:service.testrequestsbyhttpstatus",
              "aggregation": "NONE",
              "percentile": null,
              "type": "AREA",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "HttpStatusClass",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 304,
        "width": 684,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Test Step Response Time",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": false,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "calc:service.teststepresponsetime",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 304,
        "width": 684,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Load Distribution by Test Step",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": false,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "calc:service.teststepresponsetime",
              "aggregation": "COUNT",
              "percentile": null,
              "type": "AREA",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "Test Step",
                  "values": [],
                  "entityDimension": false
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 0,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Load Testing Overall Request Count",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "calc:service.teststepresponsetime",
              "aggregation": "COUNT",
              "percentile": null,
              "type": "AREA",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 0,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Load Testing Request Throughput",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "SINGLE_VALUE",
          "series": [
            {
              "metric": "calc:service.teststepresponsetime",
              "aggregation": "COUNT",
              "percentile": null,
              "type": "AREA",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.service",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "MINUTE"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "System Insights",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 1330,
        "width": 342,
        "height": 38
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      }
    },
    {
      "name": "Host health",
      "tileType": "HOSTS",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 1330,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": null,
      "chartVisible": true
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 988,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Node.js GC heap used",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": false,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:tech.nodejs.v8heap.gcHeapUsed",
              "aggregation": "AVG",
              "percentile": null,
              "type": "BAR",
              "entityType": "PROCESS_GROUP_INSTANCE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.process_group_instance",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 988,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Node.js Active handles",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": false,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:tech.nodejs.uvLoop.activeHandles",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "PROCESS_GROUP_INSTANCE",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.process_group_instance",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 1330,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Traffic in",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": false,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.net.nic.trafficIn",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.host",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "dt.entity.network_interface",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 1330,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Traffic out",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.net.nic.trafficOut",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.host",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "dt.entity.network_interface",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Service Insights",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 988,
        "width": 342,
        "height": 38
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      }
    },
    {
      "name": "Service health",
      "tileType": "SERVICES",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 988,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": null,
      "chartVisible": true
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 1330,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Memory used %",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.mem.usage",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.host",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 684,
        "left": 1330,
        "width": 342,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Disk used %",
        "defaultName": "Custom chart",
        "chartConfig": {
          "legendShown": true,
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.disk.usedPct",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [
                {
                  "id": "0",
                  "name": "dt.entity.host",
                  "values": [],
                  "entityDimension": true
                },
                {
                  "id": "1",
                  "name": "dt.entity.disk",
                  "values": [],
                  "entityDimension": true
                }
              ],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      }
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 0,
        "width": 988,
        "height": 76
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "markdown": "## Application Under Test Insights\n\n[Diagnostics of Test Steps](https://'$DT_TENANT'/ui/diagnostictools/mda?gtf=l_2_HOURS&gf=all&metric=RESPONSE_TIME&dimension=%7BRequestAttribute:TSN%7D&aggregation=AVERAGE&chart=LINE&servicefilter=0%1E15%11ad4a5402-f253-4d84-ae93-debf5904e8d6)\n- [Service Flow](https://'$DT_TENANT'/#serviceflow;sci=SERVICE-A8737F1ED40B8C8F) - [Top Web Requests](https://'$DT_TENANT'/#topglobalwebrequests;sci=SERVICE-A8737F1ED40B8C8F) - [Method Hotspot Analysis](https://'$DT_TENANT'/#responsetimeanalysis;sci=SERVICE-A8737F1ED40B8C8F) - [Outlier Analysis](https://'$DT_TENANT'/#responsetimedistribution;sci=SERVICE-A8737F1ED40B8C8F) - [PurePaths](https://'$DT_TENANT'/#servicecalls;sci=SERVICE-A8737F1ED40B8C8F)"
    }
  ]
}'

echo ""
echo "Creating Dashboard"
echo "$PAYLOAD"
curl -X POST \
        "https://$DT_TENANT/api/config/v1/dashboards" \
        -H 'accept: application/json; charset=utf-8' \
        -H "Authorization: Api-Token $DT_API_TOKEN" \
        -H 'Content-Type: application/json; charset=utf-8' \
        -d "$PAYLOAD" \
        -o curloutput.txt

cat curloutput.txt
echo ""
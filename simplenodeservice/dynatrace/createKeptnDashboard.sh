#!/bin/bash

# Usage:
# ./createKeptnDashboard.sh DashboardName

if [[ -z "$DT_TENANT" ]]; then
  DT_TENANT=$(cat ~/dynatrace-service/deploy/scripts/creds_dt.json | jq -r '.dynatraceTenant')
fi
if [[ -z "$DT_API_TOKEN" ]]; then
  DT_API_TOKEN=$(cat ~/dynatrace-service/deploy/scripts/creds_dt.json | jq -r '.dynatraceApiToken')
fi
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
  DASHBOARDNAME="@keptnProject: Digitial Delivery & Operations Dashboard"
fi

# TODO: Query Synthetic Test & Web Application

echo "============================================================="
echo "About to create $1 on Dynatrace Tenant: $DT_TENANT for Keptn Domain $KEPTN_DOMAIN"
echo "============================================================="
read -rsp $'Press ctrl-c to abort. Press any key to continue...\n' -n1 key

PAYLOAD='
{
  "dashboardMetadata": {
    "name": "'$DASHBOARDNAME'",
    "shared": true,
    "owner": "",
    "sharingDetails": {
      "linkShared": true,
      "published": false
    },
    "dashboardFilter": {
      "timeframe": "l_7_DAYS",
      "managementZone": null
    }
  },
  "tiles": [
    {
      "name": "",
      "tileType": "HOSTS",
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
        "type": "HOST",
        "customName": "Hosts",
        "defaultName": "Hosts",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {}
      },
      "chartVisible": true
    },
    {
      "name": "",
      "tileType": "SERVICES",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 304,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "NON_DATABASE_SERVICE",
        "customName": "Services",
        "defaultName": "Services",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "NON_DATABASE_SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:staging"
            ]
          }
        }
      },
      "chartVisible": true
    },
    {
      "name": "",
      "tileType": "SERVICES",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 608,
        "width": 570,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "NON_DATABASE_SERVICE",
        "customName": "Services",
        "defaultName": "Services",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [],
          "resultMetadata": {}
        },
        "filtersPerEntityType": {
          "NON_DATABASE_SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:prod"
            ]
          }
        }
      },
      "chartVisible": true
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 304,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Throughput Staging",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.requestCount.total",
              "aggregation": "NONE",
              "percentile": null,
              "type": "BAR",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-27459F62C8316B0B": {
              "lastModified": 1569238850638,
              "customColor": "#0000ff"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:staging"
            ]
          }
        }
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 228,
        "left": 608,
        "width": 570,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Throughput - Production",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.requestCount.total",
              "aggregation": "NONE",
              "percentile": null,
              "type": "BAR",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-1B151929B3D086BCbuiltin:service.requestCount.total|NONE|TOTAL|BAR|SERVICE": {
              "lastModified": 1575035953312,
              "customColor": "#bee5a3"
            },
            "SERVICE-FA34573241986FE5": {
              "lastModified": 1569235535916,
              "customColor": "#bee5a3"
            },
            "SERVICE-F7587BAF4C515CC6builtin:service.requestCount.total|NONE|TOTAL|BAR|SERVICE": {
              "lastModified": 1575035877100,
              "customColor": "#008cdb"
            },
            "SERVICE-CE2BB217F7FAAB42": {
              "lastModified": 1569235490037,
              "customColor": "#008cdb"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:prod"
            ]
          }
        }
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 304,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Failure Rate Staging",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.errors.server.rate",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-27459F62C8316B0B": {
              "lastModified": 1569238811703,
              "customColor": "#ff0000"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:staging"
            ]
          }
        }
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 608,
        "width": 570,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Failure Rate Production",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.errors.server.rate",
              "aggregation": "AVG",
              "percentile": null,
              "type": "BAR",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-FA34573241986FE5": {
              "lastModified": 1569235940037,
              "customColor": "#bee5a3"
            },
            "SERVICE-CE2BB217F7FAAB42": {
              "lastModified": 1569235944585,
              "customColor": "#008cdb"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:prod"
            ]
          }
        }
      }
    },
    {
      "name": "Docker",
      "tileType": "DOCKER",
      "configured": true,
      "bounds": {
        "top": 532,
        "left": 0,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
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
        "customName": "CPU",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.cpu.load",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [],
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
        "customName": "Disk",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:host.disk.free",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "HOST",
              "dimensions": [
                {
                  "id": "1",
                  "name": "Disk",
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
      "name": "Business",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 1178,
        "width": 304,
        "height": 38
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      }
    },
    {
      "name": "Web application",
      "tileType": "APPLICATION",
      "configured": true,
      "bounds": {
        "top": 76,
        "left": 1178,
        "width": 304,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "assignedEntities": [
        "APPLICATION-EA7C4B59F27D43EB"
      ]
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 304,
        "width": 304,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response Time - Staging",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.response.time",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-27459F62C8316B0B": {
              "lastModified": 1569238833800,
              "customColor": "#7c38a1"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:staging"
            ]
          }
        }
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 608,
        "width": 570,
        "height": 152
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Response Time - Production",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "builtin:service.response.time",
              "aggregation": "AVG",
              "percentile": null,
              "type": "LINE",
              "entityType": "SERVICE",
              "dimensions": [],
              "sortAscending": false,
              "sortColumn": true,
              "aggregationRate": "TOTAL"
            }
          ],
          "resultMetadata": {
            "SERVICE-FA34573241986FE5": {
              "lastModified": 1569236027734,
              "customColor": "#7dc540"
            },
            "SERVICE-1B151929B3D086BCbuiltin:service.response.time|AVG|TOTAL|LINE|SERVICE": {
              "lastModified": 1575035927676,
              "customColor": "#7dc540"
            },
            "SERVICE-F7587BAF4C515CC6builtin:service.response.time|AVG|TOTAL|LINE|SERVICE": {
              "lastModified": 1575035915406,
              "customColor": "#008cdb"
            },
            "SERVICE-CE2BB217F7FAAB42": {
              "lastModified": 1569235913182,
              "customColor": "#008cdb"
            }
          }
        },
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:prod"
            ]
          }
        }
      }
    },
    {
      "name": "Browser monitor",
      "tileType": "SYNTHETIC_SINGLE_WEBCHECK",
      "configured": true,
      "bounds": {
        "top": 380,
        "left": 1178,
        "width": 304,
        "height": 304
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "assignedEntities": [
        "SYNTHETIC_TEST-262661E06F002F64"
      ],
      "excludeMaintenanceWindows": false
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 304,
        "width": 304,
        "height": 76
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "markdown": "## Staging\n[Open in Browser](http://simplenode.simpleproject-staging.'$KEPTN_DOMAIN')"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 0,
        "width": 304,
        "height": 76
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "markdown": "## Operations\n[Open Keptns Bridge](https://bridge.keptn.'$KEPTN_DOMAIN'/?#/)"
    },
    {
      "name": "Markdown",
      "tileType": "MARKDOWN",
      "configured": true,
      "bounds": {
        "top": 0,
        "left": 608,
        "width": 570,
        "height": 76
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "markdown": "## Production (Canary/Primary)\n[Open in Browser](http://simplenode.simpleproject-prod.'$KEPTN_DOMAIN')"
    },
    {
      "name": "Custom chart",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 722,
        "left": 0,
        "width": 608,
        "height": 228
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Service Calls per Test Name",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "calc:service.teststepservicecalls",
              "aggregation": "NONE",
              "percentile": null,
              "type": "BAR",
              "entityType": "SERVICE",
              "dimensions": [
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
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:staging"
            ]
          }
        }
      }
    },
    {
      "name": "Arch Validation: Service-to-Service Interaction by Test",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 684,
        "left": 0,
        "width": 608,
        "height": 38
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      }
    },
    {
      "name": "Arch Validation: Service-to-Service Interaction by Business Transaction",
      "tileType": "HEADER",
      "configured": true,
      "bounds": {
        "top": 684,
        "left": 608,
        "width": 874,
        "height": 38
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      }
    },
    {
      "name": "",
      "tileType": "CUSTOM_CHARTING",
      "configured": true,
      "bounds": {
        "top": 722,
        "left": 608,
        "width": 874,
        "height": 228
      },
      "tileFilter": {
        "timeframe": null,
        "managementZone": null
      },
      "filterConfig": {
        "type": "MIXED",
        "customName": "Top Service Calls per API Endpoint",
        "defaultName": "Custom chart",
        "chartConfig": {
          "type": "TIMESERIES",
          "series": [
            {
              "metric": "calc:service.topurlservicecalls",
              "aggregation": "NONE",
              "percentile": null,
              "type": "BAR",
              "entityType": "SERVICE",
              "dimensions": [
                {
                  "id": "1",
                  "name": "URL",
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
        "filtersPerEntityType": {
          "SERVICE": {
            "AUTO_TAGS": [
              "keptn_stage:prod"
            ]
          }
        }
      }
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
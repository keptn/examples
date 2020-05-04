#!/bin/bash

if [ -z $1 ]
then
  echo "gen_load http://servicendpoint Production|Staging"
  exit 1
fi

if [ -z $2 ]
then
  echo "gen_load http://servicendpoint Production|Staging"
  exit 1
fi

echo "Load Test Launched against $1 - $2 "  >> ./loadtest.log
while [ ! -f ./endloadtest.txt ];
do
  # In Production we sleep less which means we will have more load
  # In Testing we also add the x-dynatrace HTTP Header so that we can demo our "load testing integration" options using Request Attributes!
  if [[ $2 == *"Production"* ]]; then
    curl -s "$1/" -o nul &> loadtest.log
    curl -s "$1/version" -o nul &> loadtest.log
    curl -s "$1/api/echo?text=This is from a production user" -o nul &> loadtest.log
    curl -s "$1/api/invoke?url=http://www.dynatrace.com" -o nul &> loadtest.log
    curl -s "$1/api/invoke?url=http://blog.dynatrace.com" -o nul &> loadtest.log

    sleep 2;
  else 
    curl -s "$1/" -H "x-dynatrace-test: TSN=Test.Homepage;" -o nul &> loadtest.log
    curl -s "$1/version" -H "x-dynatrace-test: TSN=Test.Version;" -o nul &> loadtest.log
    curl -s "$1/api/echo?text=This is from a testing script" -H "x-dynatrace-test: TSN=Test.Echo;" -o nul &> loadtest.log
    curl -s "$1/api/invoke?url=http://www.dynatrace.com" -H "x-dynatrace-test: TSN=Test.Invoke;" -o nul &> loadtest.log

    sleep 5;
  fi
done;
exit 0
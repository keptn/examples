#!/bin/bash
CREDS=./creds.json
rm $CREDS

echo Please enter the credentials as requested below:  
read -p "Dynatrace Tenant: (default=$DTENV)" DTENVC
read -p "Dynatrace API Token: (default=$DTAPI) " DTAPIC
read -p "Dynatrace PaaS Token: (default=$DTAPI) " DTPAAST
read -p "github User Name: " GITU 
read -p "github Personal Access Token: " GITAT
read -p "github User Email: " GITE
read -p "github Organization: " GITO
echo ""

if [[ $DTENV = '' ]]
then 
  DTENV=$DTENVC
fi

if [[ $DTAPI = '' ]]
then 
  DTAPI=$DTAPIC
fi

echo ""
echo "Please confirm all are correct:"
echo "Dynatrace Tenant: $DTENV"
echo "Dynatrace API Token: $DTAPI"
echo "Dynatrace PaaS Token: $DTPAAST"
echo "github User Name: $GITU"
echo "github Personal Access Token: $GITAT"
echo "github User Email: $GITE"
echo "github Organization: $GITO" 
read -p "Is this all correct?" -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]
then
  rm $CREDS
  cat ./creds.sav | sed 's/DYNATRACE_TENANT_PLACEHOLDER/'"$DTENV"'/' | \
  sed 's/DYNATRACE_API_TOKEN/'"$DTAPI"'/' | \
  sed 's/DYNATRACE_PAAS_TOKEN/'"$DTPAAST"'/' | \
  sed 's/GITHUB_USER_NAME_PLACEHOLDER/'"$GITU"'/' | \
  sed 's/PERSONAL_ACCESS_TOKEN_PLACEHOLDER/'"$GITAT"'/' | \
  sed 's/GITHUB_USER_EMAIL_PLACEHOLDER/'"$GITE"'/' | \
  sed 's/GITHUB_ORG_PLACEHOLDER/'"$GITO"'/' >> $CREDS
fi

cat $CREDS
echo ""
echo "the creds file can be found here:" $CREDS
echo ""

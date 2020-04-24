#!/bin/bash
echo "Usage: ./generate_traffic.sh [domain]"
echo "Press [CTRL+C] to stop.."

if [ $# -eq 0 ]; then
    KEPTN_DNS="svc.cluster.local"
    stages=( carts.sockshop-dev carts-primary.sockshop-staging carts-primary.sockshop-production )
    echo "No domain provided, using the internal DNS of cluster"
else 
    KEPTN_DNS=$1
    echo "Using this domain: $KEPTN_DNS"
    stages=( carts.sockshop-dev carts.sockshop-staging carts.sockshop-production )
fi

# Declare variables
contentType="Content-Type: application/json"
dtHeaderGet="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Get Items in cart;"
dtHeaderAdd="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Get Items in cart;"
dtHeaderDelete="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Empty Cart;"
jsonPayload="{\"id\":\"3395a43e-2d88-40de-b95f-e00e1502085b\", \"itemId\":\"03fef6ac-1896-4ce8-bd69-b798f85c6e0b\"}"
cartNr=2

max_items=10
i=0
t=0.1

get_add_delete_items_all_stages(){
  while true
  do
    # Endless loop
    for stage in "${stages[@]}"
    do
      url_cart="http://$stage.$KEPTN_DNS/carts/$cartNr"
      url_items=$url_cart"/items"
      # we get items continuesly
      add_item
      sleep $t
      get_item
      sleep $t
      # After 10 items we delete and add 1
      if [ $i -ge $max_items ];  then
        delete_items
        sleep $t
        add_item
        sleep $t
      fi
    done
    if [ $i -ge $max_items ];  then
      i=0
    fi
    i=$((i+1))
  done
}

check_items_all_stages(){
  while true
  do
  # Endless loop
  for stage in "${stages[@]}"
    do
    url_cart="http://$stage.$KEPTN_DNS/carts/$cartNr"
    url_items=$url_cart"/items"
    echo -e "\n getting url $url_items"
    get_item
    sleep $t
    done
  done
}

delete_items(){
  echo -e "\nDELETE:$url_items"
  curl -X DELETE -H "$dtHeaderDelete" $url_cart
}

add_item(){
  echo -e "\nPOST:$url_items"
  curl -X POST -H "$contentType" -H "$dtHeaderAdd" -d "$jsonPayload" $url_items
}

get_item(){
  echo -e "\nGET:$url_items"
  curl -X GET -H "$contentType" -H "$dtHeaderGet" $url_items
}

#check_items_all_stages
#add_delete_items_all_stages
get_add_delete_items_all_stages
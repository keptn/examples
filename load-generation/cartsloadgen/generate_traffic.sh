#!/bin/bash
echo "Usage: ./generate_traffic.sh [domain]"
echo "Press [CTRL+C] to stop.."

echo "Using this domain: $KEPTN_DOMAIN"
stages=( $CARTS_STAGES )
echo $stages

# Declare variables
contentType="Content-Type: application/json"
dtHeaderGet="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Get Items from cart;"
dtHeaderAdd="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Add Item to cart;"
dtHeaderDelete="x-dynatrace-test: LSN=generate_traffic.sh;LTN=Traffic generation;TSN=Empty Cart;"
jsonPayload="{\"id\":\"$CARTS_ID\", \"itemId\":\"$ITEM_ID\", \"price\":\"99.90\"}"
cartNr=1

max_items=$MAX_CARTS_ITEMS
i=0
t=$SLEEP_TIME

get_add_delete_items_all_stages(){
  while true
  do
    # Endless loop
    for stage in "${stages[@]}"
    do
      url_cart="http://$stage.$KEPTN_DOMAIN/carts/$cartNr"
      url_items=$url_cart"/items"
      # we get items continuesly
      add_item
      sleep $t
      get_item
      sleep $t
      # After X items we delete and add 1
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
    url_cart="http://$stage.$KEPTN_DOMAIN/carts/$cartNr"
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
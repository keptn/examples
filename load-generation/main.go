package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
)

const healthyitemid = "03fef6ac-1896-4ce8-bd69-b798f85c6e0b"
const faultyitemid = "03fef6ac-1896-4ce8-bd69-b798f85c6e0f"

func main() {

	if len(os.Args) < 2 {
		fmt.Println("please provide URL of carts service")
		return
	}
	url := os.Args[1]

	if url == "" {
		fmt.Println("no URL set")
		return
	}

	item := healthyitemid

	if len(os.Args) == 3 {
		problem := os.Args[2]
		if problem == "cpu" {
			item = faultyitemid
		}
	}

	itemData := map[string]interface{}{
		"itemId":    item,
		"unitPrice": "99.99",
	}
	b, _ := json.Marshal(itemData)
	url = url + "/carts/1/items"

	fmt.Println("Exit program with CTRL+C")
	fmt.Println()
	for true {
		resp, err := http.Post(url, "application/json", bytes.NewBuffer(b))
		if err != nil {
			log.Fatalln(err)
		}

		var result map[string]interface{}

		json.NewDecoder(resp.Body).Decode(&result)
		log.Println(result)
	}
}

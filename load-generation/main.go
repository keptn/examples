package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"
)

const healthyitemid = "03fef6ac-1896-4ce8-bd69-b798f85c6e0b"
const faultyitemid = "03fef6ac-1896-4ce8-bd69-b798f85c6e0f"

var wg sync.WaitGroup

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

	if len(os.Args) >= 3 {
		problem := os.Args[2]
		if problem == "cpu" {
			item = faultyitemid
		}
	}

	var numberOfThreads int
	numberOfThreads = 1
	if len(os.Args) >= 4 {
		numberOfThreadsInt64, err := strconv.ParseInt(os.Args[3], 10, 64)
		if err != nil {
			numberOfThreads = 1
		} else {
			numberOfThreads = int(numberOfThreadsInt64)
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

	tr := &http.Transport{
		DialContext: resolveXipIoWithContext,
	}
	c := &http.Client{Timeout: 3 * time.Second, Transport: tr}

	wg.Add(numberOfThreads)
	for i := 0; i < numberOfThreads; i++ {
		go doRequests(url, b, c)
		fmt.Println("Created new Thread")
	}
	wg.Wait()

}

func doRequests(url string, b []byte, c *http.Client) {
	defer wg.Done()
	for true {
		req, err := http.NewRequest("POST", url, bytes.NewBuffer(b))
		if err != nil {
			log.Fatalln(err)
		}
		req.Header.Set("X-Custom-Header", "myvalue")
		req.Header.Set("Content-Type", "application/json")

		resp, err := c.Do(req)

		if err != nil {
			continue
		}

		if resp.StatusCode == 201 {
			var result map[string]interface{}
			json.NewDecoder(resp.Body).Decode(&result)
			log.Println(result)
		}
		resp.Body.Close()
	}
}

// resolveXipIo resolves a xip io address
func resolveXipIoWithContext(ctx context.Context, network, addr string) (net.Conn, error) {
	dialer := &net.Dialer{
		DualStack: true,
	}

	if strings.Contains(addr, ".xip.io") {

		regex := `\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).xip.io\b`
		re := regexp.MustCompile(regex)
		ipWithXipIo := re.FindString(addr)
		ip := ipWithXipIo[:len(ipWithXipIo)-len(".xip.io")]

		regex = `:\d+$`
		re = regexp.MustCompile(regex)
		port := re.FindString(addr)

		var newAddr string
		if port != "" {
			newAddr = ip + port
		}
		addr = newAddr
	}
	return dialer.DialContext(ctx, network, addr)
}

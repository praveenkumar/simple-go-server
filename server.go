package main

import (
	"errors"
	"fmt"
	"net/http"
	"os"
)

func hello(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("got / request\n")
	fmt.Fprintf(w, "hello\n")
}

func version(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("got /version request\n")
	fmt.Fprintf(w, "v1\n")
}

func headers(w http.ResponseWriter, req *http.Request) {
	fmt.Printf("got /headers request\n")
	for name, headers := range req.Header {
		for _, h := range headers {
			fmt.Fprintf(w, "%v: %v\n", name, h)
		}
	}
}

func main() {
	http.HandleFunc("/", hello)
	http.HandleFunc("/headers", headers)
	http.HandleFunc("/version", version)

	err := http.ListenAndServe(":8080", nil)
	if errors.Is(err, http.ErrServerClosed) {
		fmt.Printf("server closed\n")
	} else if err != nil {
		fmt.Printf("error starting server: %s\n", err)
		os.Exit(1)
	}
}

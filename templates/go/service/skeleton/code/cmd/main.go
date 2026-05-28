package main

import (
	"fmt"
	"net/http"
)

func main() {
	projectName := "${{ values.name }}"

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from %s!", projectName)
	})

	fmt.Printf("Starting %s server on port 8080...\n", projectName)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

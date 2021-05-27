package main

import (
	"encoding/json"
	"net/http"
	"os"
	"strings"
)

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	var env = map[string]string{}
	for _, value := range os.Environ() {
		pair := strings.SplitN(value, "=", 2)
		env[pair[0]] = pair[1]
	}

	json.NewEncoder(w).Encode(env)
}

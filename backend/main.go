package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
)

const port = 8080

func statusHandler(rw http.ResponseWriter, r *http.Request) {
	var payload = struct {
		Status  string `json:"status"`
		Version string `json:"version"`
	}{
		Status:  "active",
		Version: "v0.0.1",
	}
	out, err := json.Marshal(payload)
	if err != nil {
		fmt.Println(err)
	}
	rw.Header().Set("Content-Type", "application/json")
	rw.WriteHeader(http.StatusOK)
	rw.Write(out)
}

func main() {
	r := chi.NewRouter()
	r.Use(middleware.Logger)
	r.Get("/status", statusHandler)
	log.Printf("backend is starting on port :%d", port)
	http.ListenAndServe(fmt.Sprintf(":%d", port), r)
}

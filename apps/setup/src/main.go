package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"

	jsonnet "github.com/google/go-jsonnet"
)

var singletonlock = &sync.Mutex{}
var criticallock = &sync.Mutex{}

var interpolator *JsonnetInterpolator

type JsonnetInterpolator struct {
	VM jsonnet.VM
}

type TemplateWithVars struct {
	Template string
	Vars     map[string]string
	AST      map[string]interface{}
	TLA      map[string]string
}

func getJPaths() []string {
	return []string{
		"/vendor",
		"/assets",
	}
}

func Interpolate(t TemplateWithVars) (string, error) {
	criticallock.Lock()
	defer criticallock.Unlock()
	getInstance().VM.ExtReset()
	getInstance().VM.Importer(&jsonnet.FileImporter{JPaths: getJPaths()})
	if t.Vars != nil {
		for key, val := range t.Vars {
			getInstance().VM.ExtVar(key, val)
		}
	}

	if t.TLA != nil {
		for key, val := range t.TLA {
			getInstance().VM.TLACode(key, val)
		}
	}

	if t.AST != nil {
		for key, val := range t.AST {
			nodemap, err := json.Marshal(val)
			if err != nil {
				return "", err
			}
			node, err := jsonnet.SnippetToAST(key, string(nodemap))

			if err != nil {
				return "", err
			}
			getInstance().VM.ExtNode(key, node)
		}
	}

	return getInstance().VM.EvaluateAnonymousSnippet("/dev/stdout", t.Template)
}

func getInstance() *JsonnetInterpolator {
	if interpolator == nil {
		singletonlock.Lock()
		defer singletonlock.Unlock()
		if interpolator == nil {
			interpolator = &JsonnetInterpolator{
				VM: *jsonnet.MakeVM(),
			}
		}
	}
	return interpolator
}

func main() {
	files, err := os.ReadDir(".")
	if err != nil {
		log.Fatal(err)
	}
	for _, file := range files {
		filename := file.Name()
		if !strings.HasSuffix(filename, ".jsonnet") {
			continue
		}

		log.Printf("Adding hook %s", filename)

		hookname := strings.TrimSuffix(filename, ".jsonnet")
		filedata, err := os.ReadFile(filename)
		if err != nil {
			log.Fatalf("can't read %q: %v", filename, err)
		}
		hookcode := string(filedata)

		http.HandleFunc("/"+hookname, func(w http.ResponseWriter, r *http.Request) {
			if r.Method != http.MethodPost {
				http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
				return
			}
			body, err := io.ReadAll(r.Body)
			if err != nil {
				http.Error(w, "Can't read body", http.StatusInternalServerError)
				return
			}
			result, err := Interpolate(
				TemplateWithVars{
					Template: hookcode,
					TLA: map[string]string{
						"request": string(body),
					},
				},
			)
			if err != nil {
				log.Printf("/%s error: %s", hookname, err)
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			fmt.Fprint(w, result)
		})
	}

	server := &http.Server{Addr: ":8080"}
	go func() {
		log.Fatal(server.ListenAndServe())
	}()

	sigchan := make(chan os.Signal, 2)
	signal.Notify(sigchan, os.Interrupt, syscall.SIGTERM)
	sig := <-sigchan
	log.Printf("Received %v signal. Shutting down...", sig)
	server.Shutdown(context.Background())
}
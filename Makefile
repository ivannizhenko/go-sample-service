BINARY_NAME := go-sample-service
MAIN_PATH := main.go

help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

## Docker build

docker_build: ## build docker image
	docker build --target build-dev -t ${BINARY_NAME}:latest .

docker_run: ## run docker container from latest image
     docker run ${BINARY_NAME}:latest

## Dev environment via Docker Compose

dev_run: ## build and start docker containers for dev environment
	docker compose --verbose up --build api

dev_migrate_up: ## run migrate up for dev environment
	docker compose run migrate-up

dev_migrate_down: ## run migrate up for dev environment
	docker compose run migrate-down

dev_stop: ## stop and remove containers, networks and orphans
	docker compose down --remove-orphans

## Local environment

lint: ## format go code
	go fmt `go list -f {{.Dir}} ./...`
	go vet `go list -f {{.Dir}} ./...`

test: clean ## run tests
	go clean -testcache
	go test -v -race `go list ./... | grep -v /vendor/`

clean: ## remove previous go build
	rm -f ${BINARY_NAME}

deps: ## install dependencies
	go mod tidy
	go mod download
	go get -v -d ./...

go_build: clean deps ## build project binary
	go build -o ${BINARY_NAME} ${MAIN_PATH}

install: clean deps ## install binary
	go install

local_run: go_build ## run server locally
	./${BINARY_NAME}
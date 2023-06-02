# go-sample-service
Golang sample service

# Run Service

## Docker
- ensure Docker and Docker Compose are installed
- use provided `.env` or create your own env file sourced from env-sample placed in project root
- run `make dev_run` to start `api` and `db` containers
- run db migrations, see [Database Config](#database-config)

## Locally
- ensure local database is installed, up and running and is configured, see [Database Config](#database-config)
- use provided `.env` or create your own env file sourced from env-sample placed in project root
- run `make go_build` to build a binary and run `./go-sample-service` to start it
- alternatively, run `make run` to build and start the service at once

# Database Config

## Docker
- run `make dev_migrate_up` to run migrations up
- in case revert is needed, run `make dev_migrate_down` to run migrations down 

## Locally
- have a local instance of postgres running.
    - `brew install postgresql`
    - `brew services`
    - `brew services start postgresql`
- run following commands in postgresql shell
```
CREATE DATABASE {POSTGRES_DB};
CREATE USER {POSTGRES_USER} WITH PASSWORD {POSTGRES_PASSWORD}';
ALTER USER {POSTGRES_USER} WITH SUPERUSER;
ALTER ROLE {POSTGRES_USER} SET client_encoding TO 'utf8';
GRANT ALL PRIVILEGES ON DATABASE {POSTGRES_DB} TO {POSTGRES_USER};
```
- run init db sql code found in `./db/migrations/000001_init_schema.up.sql`

# Sample requests
- to get all products, run `curl -X GET "http://127.0.0.1:8001/products?count=10&start=0" -H  "accept: application/json"`
- to add a product, run `curl -X POST "http://127.0.0.1:8001/product" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"id\":1,\"name\":\"Scrub Daddy\",\"price\":3.69}"`
- to get a specific product, run `curl -X GET "http://127.0.0.1:8001/product/1" -H  "accept: application/json"`
- to update existing product, run `curl -X PUT "http://127.0.0.1:8001/product/1" -H  "accept: application/json" -H  "Content-Type: application/json" -d "{\"name\":\"Scrub Daddy 2\",\"price\":3.99}"`
- to delete the product, run `curl -X DELETE "http://127.0.0.1:8001/product/1" -H  "accept: */*"`

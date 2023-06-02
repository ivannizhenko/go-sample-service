FROM golang:1.18.0 AS base

FROM base as builder
WORKDIR /app
COPY . /app
RUN make go_build

FROM alpine:latest as build-dev
RUN apk --no-cache add ca-certificates libc6-compat postgresql-client
WORKDIR /app
COPY --from=builder /app/.env .
COPY --from=builder /app/go-sample-service .
CMD ["./go-sample-service"]
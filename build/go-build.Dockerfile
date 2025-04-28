FROM golang:1.24-alpine AS build
ENV CGO_ENABLED=0

RUN apk add --no-cache gcc musl-dev

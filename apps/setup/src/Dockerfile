FROM golang:1.22.7 AS build
ARG TARGETARCH

COPY . /go/src/setup/
WORKDIR /go/src/setup/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -o /go/bin/taocesetupcontroller

FROM scratch AS export

COPY --from=build /go/bin/taocesetupcontroller /go/bin/taocesetupcontroller
COPY ./hooks /hooks
COPY ./assets /assets
# COPY ./vendor /vendor
WORKDIR /hooks
ENTRYPOINT  ["/go/bin/taocesetupcontroller"]
EXPOSE 8080
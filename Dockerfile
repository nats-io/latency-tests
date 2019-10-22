FROM golang:1.11-alpine3.8 AS builder

WORKDIR $GOPATH/src/github.com/nats-io/latency-tests/

MAINTAINER Waldemar Quevedo <wally@synadia.com>

RUN apk add --update git

COPY . .

RUN CGO_ENABLED=0 GO111MODULE=on go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w" -o /latency-tests

FROM alpine:3.8

RUN apk add --update ca-certificates && apk add tcptraceroute

COPY --from=builder /latency-tests /bin/latency-tests

ENTRYPOINT ["/bin/sh"]

FROM golang:1.11.11-alpine3.10 AS builder

WORKDIR $GOPATH/src/github.com/nats-io/latency-tests/

MAINTAINER Waldemar Quevedo <wally@synadia.com>

RUN apk add --update git

COPY . .

RUN CGO_ENABLED=0 go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w" -o /latency-tests

FROM alpine:3.10

RUN apk add --update ca-certificates && apk add --no-cache tcptraceroute

COPY --from=builder /latency-tests /bin/latency-tests

ENTRYPOINT ["/bin/sh"]

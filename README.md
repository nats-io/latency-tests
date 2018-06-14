# NATS Latency and Throughput Test Framework

### Install
```
go get github.com/nats-io/latency-tests
```

### Running a local NATS server.

You do not need a local server to run the test framework. However if you want to do so, the recommended way to install the NATS server is to [download](http://nats.io/download/) one of the pre-built release binaries which are available for OSX, Linux (x86-64/ARM), Windows, and Docker. Instructions for using these binaries are on the [GitHub releases page][github-release].


[github-release]: https://github.com/nats-io/gnatsd/releases/

### Running a test.

```
> go build latency.go
> ./latency.go -h
Usage: latency [-sa serverA] [-sb serverB] [-sz msgSize] [-tr msgs/sec] [-tt testTime] [-hist <file>]
>
```

The test framework will run a test to publish and subscribe to messages. Publish operations will happen on one connection to ServerA, and Subscriptions will be on another connection to ServerB. ServerA and ServerB can be the same server.

You are able to specify various options such as message size [-sz], transmit rate [-tr], test time duration [-tt], and output file for plotting with http://hdrhistogram.github.io/HdrHistogram/plotFiles.html.

### Example
```
> ./latency -sa tls://demo.nats.io:4443 -sb tls://demo.nats.io:4443 -tr 1000 -tt 5s -sz 512
```

This example will connect both connections to a secure demo server, attempting to send at 1000 msgs/sec with each message payload being 512 bytes long. This test duration will be ~5 seconds.

### Output
```bash

==============================
Pub Server RTT : 13ms
Sub Server RTT : 12ms
Message Payload: 512B
Target Duration: 5s
Target Msgs/Sec: 1000
Target Band/Sec: 1000K
==============================
Actual Msgs/Sec: 973
Actual Band/Sec: 973K
Actual Duration: 5.146s
HDR Percentiles:
10:     13ms
50:     13ms
75:     14ms
90:     17ms
99:     20ms
99.99:  21ms
==============================

```

This is output from the previous example run. The test framework will establish a rough estimate of the RTT to each server via a call to ``nats.Flush()``. The message payload size, test duration and target msgs/sec and subsequent bandwidth will be noted. After the test completes the actual results of achieved msgs/sec, bandwidth/sec and test duration are printed. We then print the histogram percentiles for 10th, 50th, 75th, 90th, 99th, and 99.99th percentiles.

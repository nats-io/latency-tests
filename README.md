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
> ./latency -h

Usage: latency-tests [options]

Test Options:
    -sa <url>        ServerA (Publish) (default: nats://localhost:4222)
    -sb <url>        ServerB (Subscribe) (default: nats://localhost:4222)
    -sz <int>        Message size in bytes (default: 8)
    -tr <int>        Rate in msgs/sec (default: 1000)
    -tt <string>     Test duration (default: 5s)
    -hist <file>     Histogram output file
    -secure          Enable TLS without verfication (default: false)
    -tls_ca <string> TLS Certificate CA file
    -tls_key <file>  TLS Private Key
    -tls_cert <file> TLS Certificate

```

The test framework will run a test to publish and subscribe to messages. Publish operations will happen on one connection to ServerA, and Subscriptions will be on another connection to ServerB. ServerA and ServerB can be the same server.

You are able to specify various options such as message size [-sz], transmit rate [-tr], test time duration [-tt], and output file for plotting with http://hdrhistogram.github.io/HdrHistogram/plotFiles.html.

### Example

```
> ./latency -sa tls://demo.nats.io:4443 -sb tls://demo.nats.io:4443 -tr 1000 -tt 5s -sz 512
```

This example will connect both connections to a secure demo server, attempting to send at 1000 msgs/sec with each message payload being 512 bytes long. This test duration will be ~5 seconds.

### Output

```text
==============================
Pub Server RTT : 1.65ms
Sub Server RTT : 2.817ms
Message Payload: 512B
Target Duration: 5s
Target Msgs/Sec: 1000
Target Band/Sec: 1000K
==============================
HDR Percentiles:
10:       1.998ms
50:       2.058ms
75:       2.095ms
90:       2.132ms
99:       2.271ms
99.99:    3.106ms
99.999:   3.126ms
99.9999:  3.126ms
99.99999: 3.126ms
100:      3.126ms
==============================
Actual Msgs/Sec: 998
Actual Band/Sec: 998K
Minimum Latency: 1.919ms
Median Latency : 2.058ms
Maximum Latency: 3.126ms
1st Sent Wall Time : 153.489ms
Last Sent Wall Time: 5.005243s
Last Recv Wall Time: 5.006857s
```

This is output from the previous example run. The test framework will establish a rough estimate of the RTT to each server via a call to ``nats.Flush()``. The message payload size, test duration and target msgs/sec and subsequent bandwidth will be noted. After the test completes the histogram percentiles for 10th, 50th, 75th, 90th, 99th,  99.99th, 99.999th, 99.9999th, 99.99999th, and 100th percentiles are printed.  After this, we print the actual results of achieved msgs/sec, bandwidth/sec, the minimum, median, and maximum latencies, and wall times recorded in the test run.  Note that the number of measurements (total messages) may cause overlap in the highest percential latency measurements, as demonstrated in the output above with 5000 measurements.

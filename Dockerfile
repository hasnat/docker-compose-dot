FROM golang:1.12 as builder

WORKDIR $GOPATH/src/github.com/hasnat/docker-compose-dot
COPY . .
RUN go get -d -v ./...
RUN go install -v ./...
ENV RLOG_LOG_LEVEL=WARN
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o /go/bin/docker-compose-dot .

FROM alpine:3.3

RUN apk add --no-cache openssl ca-certificates
COPY --from=builder /go/bin/docker-compose-dot /docker-compose-dot

ENTRYPOINT ["/docker-compose-dot"]

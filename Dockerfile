FROM quay.io/projectquay/golang:1.26 AS builder
ARG APP_NAME
ARG HOST_ARCH
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=${HOST_ARCH} go build -o bin/${APP_NAME} .

FROM scratch
ARG APP_NAME
WORKDIR /
COPY --from=builder /go/src/app/bin/${APP_NAME} ./app
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs
ENTRYPOINT ["./app"]

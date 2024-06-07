FROM ghcr.io/goccy/go-zetasql:latest
# FROM golang:1.21-bookworm

ARG VERSION

WORKDIR /work

COPY . ./

copy certs.d/* /etc/ssl/certs/

RUN go mod edit -replace github.com/goccy/go-zetasql=../go-zetasql
RUN go mod download

RUN make emulator/build

FROM debian:bullseye AS emulator

COPY --from=0 /work/bigquery-emulator /bin/bigquery-emulator

WORKDIR /work

ENTRYPOINT ["/bin/bigquery-emulator"]

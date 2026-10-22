FROM --platform=$BUILDPLATFORM registry.access.redhat.com/ubi9/go-toolset:1.26 AS builder

ARG TARGETOS
ARG TARGETARCH

USER root
WORKDIR /workspace
COPY go.mod ./
COPY server.go .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -trimpath -ldflags="-s -w" -o myserver .

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8

LABEL org.opencontainers.image.authors="Praveen Kumar <prkumar@redhat.com>" \
      org.opencontainers.image.source="https://github.com/praveenkumar/simple-go-server" \
      org.opencontainers.image.version="v1"

COPY --from=builder /workspace/myserver /usr/bin/myserver

EXPOSE 8080/tcp

USER 1000:1000

ENTRYPOINT ["myserver"]

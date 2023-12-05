FROM registry.access.redhat.com/ubi9/go-toolset:latest as builder

USER root
WORKDIR /workspace
COPY . .
RUN go build -o myserver server.go

FROM registry.access.redhat.com/ubi9/ubi-minimal

LABEL MAINTAINER "Praveen Kumar <prkumar@redhat.com>"

COPY --from=builder /workspace/myserver /usr/bin/myserver

EXPOSE 8080/tcp

ENTRYPOINT ["myserver"]

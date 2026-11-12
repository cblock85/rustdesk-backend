# One image with the ID server (hbbs), relay server (hbbr), API server and
# admin panel, all built from the sources in this repository.

FROM node:20-alpine AS web
WORKDIR /src
COPY web/package.json web/package-lock.json ./
RUN npm ci
COPY web/ ./
RUN npm run build

FROM golang:1.24-alpine AS api
RUN apk add --no-cache build-base
WORKDIR /src
COPY api/ ./
RUN go mod tidy \
 && CGO_ENABLED=1 go build -ldflags "-s -w -extldflags -static" -o /out/apimain ./cmd/apimain.go

FROM rust:1-alpine AS server
RUN apk add --no-cache build-base
WORKDIR /src
COPY server/ ./
RUN cargo build --release \
 && mkdir /out \
 && cp target/release/hbbs target/release/hbbr target/release/rustdesk-utils /out/

FROM alpine:3.20
ARG S6_OVERLAY_VERSION=3.2.0.0
ARG TARGETARCH
RUN apk add --no-cache tzdata ca-certificates xz \
 && case "${TARGETARCH:-amd64}" in \
      amd64) S6_ARCH=x86_64 ;; \
      arm64) S6_ARCH=aarch64 ;; \
      *) echo "unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac \
 && wget -qO /tmp/s6-noarch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
 && wget -qO /tmp/s6-arch.tar.xz "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
 && tar -C / -Jxpf /tmp/s6-noarch.tar.xz \
 && tar -C / -Jxpf /tmp/s6-arch.tar.xz \
 && rm /tmp/s6-*.tar.xz \
 && ln -s /run /var/run

COPY server/docker/rootfs /
COPY server/docker/healthcheck.sh /usr/bin/healthcheck.sh
COPY --from=server /out/ /usr/bin/
COPY --from=api /out/apimain /app/apimain
COPY api/resources /app/resources
COPY api/docs /app/docs
COPY api/conf /app/conf
COPY --from=web /src/dist /app/resources/admin
RUN chmod +x /usr/bin/healthcheck.sh /etc/s6-overlay/s6-rc.d/*/run \
 && mkdir -p /app/runtime /app/data \
 && echo "/package/admin/s6/command/s6-svstat /run/s6-rc/servicedirs/api || exit 1" >> /usr/bin/healthcheck.sh

ENV RELAY=relay.example.com \
    ENCRYPTED_ONLY=1

EXPOSE 21114 21115 21116 21116/udp 21117 21118 21119
HEALTHCHECK --interval=10s --timeout=5s CMD /usr/bin/healthcheck.sh
WORKDIR /app
VOLUME /app/data
VOLUME /data
ENTRYPOINT ["/init"]

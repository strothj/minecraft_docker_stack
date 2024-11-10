FROM caddy:2.8.4-builder-alpine AS builder
ARG CADDY_L4_VERSION=16b3b200e1828ec0ad7cfdf88bf67b3a0c80cda0

RUN xcaddy build --with github.com/mholt/caddy-l4@$CADDY_L4_VERSION

FROM debian:bookworm-20241016-slim AS gosu-installer
ARG CA_CERTIFICATES_VERSION=20230311
ARG GOSU_VERSION=1.17
ARG GPG_VERSION=2.2.40-1.1

ADD --link https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64 /gosu
ADD --link https://github.com/tianon/gosu/releases/download/1.17/gosu-amd64.asc /gosu.asc

RUN <<EOF
  set -ex
  apt-get update
  apt-get install -y ca-certificates=$CA_CERTIFICATES_VERSION gpg=$GPG_VERSION
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
  set -ex
  gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
  gpg --batch --verify gosu.asc gosu
EOF

FROM caddy:2.8.4-alpine
EXPOSE 25564
EXPOSE 25565

RUN adduser -D -u 1000 caddy

COPY --chown=root:root --chmod=555 --from=builder --link /usr/bin/caddy /usr/bin/caddy
COPY --chown=root:root --chmod=554 --from=gosu-installer --link /gosu /usr/local/bin/
COPY --chown=caddy:caddy --chmod=400 --link config.json /config.json
COPY --chown=root:root --chmod=554 entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

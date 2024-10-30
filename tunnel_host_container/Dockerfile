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

FROM debian:bookworm-20241016-slim
ARG OPENSSH_SERVER_VERSION=1:9.2p1-2+deb12u3
EXPOSE 1022

RUN <<EOF
  set -ex
  apt-get update
  apt-get install -y openssh-server=$OPENSSH_SERVER_VERSION
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
  set -ex
  groupadd --gid 1000 tunnel
  useradd \
    --create-home \
    --gid tunnel \
    --no-log-init \
    --system \
    --uid 1000 \
    tunnel
EOF

COPY --chmod=554 --from=gosu-installer --link /gosu /usr/local/bin/

COPY --chown=root --chmod=544 entrypoint.sh /
ENTRYPOINT ["./entrypoint.sh"]
CMD [ \
  # Drop privileges.
  "gosu", "tunnel", \
  \
  "/usr/sbin/sshd", \
  # Do not detach and do not become a daemon.
  "-D", \
  # Write debug logs to standard error.
  "-e",  \
  # Specify host key file because service is not running as host.
  "-h", "/home/tunnel/.ssh/ssh_host_ed25519_key", \
  # Allow forwarded ports on addresses other than localhost.
  "-o", "GatewayPorts=clientspecified", \
  # Don't write a process ID file.
  "-o", "PidFile=none", \
  # Use a unprivileged port.
  "-p", "1022" \
  ]

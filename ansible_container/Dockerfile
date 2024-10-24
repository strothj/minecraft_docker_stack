FROM debian:bookworm-20241016-slim
ARG ANSIBLE_VERSION=10.5.0
ARG PYTHON_VERSION=3.11.2-1+b1

RUN <<EOF
  set -ex
  apt-get update
  apt-get install -y \
    python3=$PYTHON_VERSION \
    python3-venv=$PYTHON_VERSION
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<EOF
  set -ex
  groupadd --gid 1000 ansible
  useradd \
    --create-home \
    --gid ansible \
    --no-log-init \
    --shell /bin/bash \
    --system \
    --uid 1000 \
    ansible
  mkdir /opt/ansible /opt/venv
  chown -R ansible:ansible /opt/ansible /opt/venv
EOF

USER ansible
WORKDIR /opt/ansible
SHELL ["/bin/bash", "-c"]

RUN <<EOF
  set -ex
  echo "source /opt/venv/bin/activate" >> ~/.bashrc
  python3 -m venv /opt/venv
  source /opt/venv/bin/activate
  python3 -m pip install ansible==$ANSIBLE_VERSION
EOF

ENV CLOUD_PROVIDER_API_KEY_FILE=/run/secrets/cloud_provider_api_key
ENV CLOUD_PROVIDER_FILE=/run/secrets/cloud_provider

COPY playbook.* /opt/ansible/

COPY --chmod=544 entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash", "-c", "while true; do sleep 1; done"]

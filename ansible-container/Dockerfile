FROM debian:bookworm-20241016-slim
ARG PYTHON_VERSION=3.11.2-1+b1
ARG ANSIBLE_VERSION=10.5.0

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
EOF

USER ansible
WORKDIR /home/ansible
SHELL ["/bin/bash", "-c"]

RUN <<EOF
  set -ex
  python3 -m venv venv
  source venv/bin/activate
  python3 -m pip install ansible==$ANSIBLE_VERSION
  echo "source venv/bin/activate" >> ~/.bashrc
EOF

FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
           ca-certificates \
           curl \
           git \
           make \
           unzip \
           python3 python3-venv python3-cryptography python3-pycparser python3-cffi python3-markupsafe python3-jinja2 python3-pyparsing \
           ruby \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

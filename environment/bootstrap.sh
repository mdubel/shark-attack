#!/usr/bin/env bash
set -euxo pipefail

DOCKER_COMPOSE_VERSION=1.25.4

sudo pip3 install pyyaml
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose version

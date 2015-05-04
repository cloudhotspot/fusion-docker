#!/bin/bash 
# Author: Justin Menga
# Email: justin.menga@gmail.com

# Variables
docker_default_path="/etc/default/docker"

# Update and install prerequisites
apt-get update && apt-get install -y wget sed

# Install Docker
wget -qO- https://get.docker.com/ | sh
usermod -aG docker vagrant

# Configure Docker daemon
grep -q '^DOCKER_OPTS=' $docker_default_path && \
	sed 's@^DOCKER_OPTS=.*@DOCKER_OPTS="-H unix:// -H tcp://0.0.0.0:2375"@' -i $docker_default_path || \
	sed '$ a\DOCKER_OPTS="-H unix:// -H tcp://0.0.0.0:2375"' -i $docker_default_path
service docker restart
#!/bin/bash

# Get the GID of the Docker group on the host
HOST_DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

# Create the docker group with the same GID as the host
groupadd -g $HOST_DOCKER_GID docker

# Add jenkins user to the docker group
usermod -aG docker jenkins

# Start Jenkins
exec /sbin/tini -- /usr/local/bin/jenkins.sh
#!/bin/bash

# Function to safely add user to group
add_user_to_group() {
    local user=$1
    local group=$2
    if ! id -nG "$user" | grep -qw "$group"; then
        usermod -aG $group $user
    fi
}

# Get the GID of the Docker group on the host
HOST_DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)

# If the docker group doesn't exist with the correct GID, create it
if ! getent group docker > /dev/null 2>&1 || [ $(getent group docker | cut -d: -f3) -ne $HOST_DOCKER_GID ]; then
    groupmod -g $HOST_DOCKER_GID docker || groupadd -g $HOST_DOCKER_GID docker
fi

# Add jenkins user to the docker group
add_user_to_group jenkins docker

# Ensure jenkins user has correct permissions
chown jenkins:jenkins /var/jenkins_home

# Start Jenkins
exec su jenkins -c "/usr/local/bin/jenkins.sh"
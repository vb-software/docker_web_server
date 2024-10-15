#!/bin/bash

# Set Jenkins UID and GID
export JENKINS_UID=$(id -u)
export JENKINS_GID=$(id -g)

# Ensure jenkins_home volume has correct permissions
docker run --rm -v jenkins_home:/var/jenkins_home alpine chown -R ${JENKINS_UID}:${JENKINS_GID} /var/jenkins_home

# Start or restart your Docker Compose setup
docker compose up jenkins -d

# Wait for Jenkins to start
echo "Waiting for Jenkins to start..."
sleep 30

# Add GitHub's host key to known_hosts
docker compose exec jenkins bash -c "ssh-keyscan github.com >> /home/jenkins/.ssh/known_hosts"

# Ensure correct permissions for .ssh directory
docker compose exec jenkins bash -c "chown -R jenkins:jenkins /home/jenkins/.ssh && chmod 700 /home/jenkins/.ssh && chmod 600 /home/jenkins/.ssh/*"

echo "Jenkins setup complete!"
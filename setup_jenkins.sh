#!/bin/bash

# Create a jenkins user on the host system with the same UID and GID as the jenkins user in the container
# The UID and GID are typically 1000, but we'll check to make sure

JENKINS_UID=$(docker run --rm jenkins/jenkins:lts id -u jenkins)
JENKINS_GID=$(docker run --rm jenkins/jenkins:lts id -g jenkins)

sudo groupadd -g $JENKINS_GID jenkins || true
sudo useradd -u $JENKINS_UID -g $JENKINS_GID -m jenkins || true

# Create and set permissions for Jenkins home directory on the host
sudo mkdir -p /var/jenkins_home
sudo chown $JENKINS_UID:$JENKINS_GID /var/jenkins_home

# Run Jenkins container
docker run -d \
  -p 8080:8080 -p 50000:50000 \
  -v /var/jenkins_home:/var/jenkins_home \
  -v $HOME/.ssh:/home/jenkins/.ssh:ro \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name jenkins \
  --user $JENKINS_UID:$JENKINS_GID \
  jenkins/jenkins:lts

# Ensure correct permissions for SSH directory
docker exec jenkins chown -R jenkins:jenkins /home/jenkins/.ssh

# Add GitHub's host key to known_hosts
docker exec --user jenkins jenkins ssh-keyscan github.com >> /home/jenkins/.ssh/known_hosts
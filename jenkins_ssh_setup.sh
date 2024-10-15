#!/bin/bash

# Ensure .ssh directory exists in Jenkins home
docker compose exec jenkins mkdir -p /var/jenkins_home/.ssh

# Set correct permissions for .ssh directory
docker compose exec jenkins chown -R jenkins:jenkins /var/jenkins_home/.ssh
docker compose exec jenkins chmod 700 /var/jenkins_home/.ssh

# Copy SSH key from host to Jenkins container
docker cp $HOME/.ssh/id_rsa jenkins:/var/jenkins_home/.ssh/id_rsa
docker compose exec jenkins chown jenkins:jenkins /var/jenkins_home/.ssh/id_rsa
docker compose exec jenkins chmod 600 /var/jenkins_home/.ssh/id_rsa

# Add GitHub's host key to known_hosts
docker compose exec jenkins ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts
docker compose exec jenkins chown jenkins:jenkins /var/jenkins_home/.ssh/known_hosts
docker compose exec jenkins chmod 644 /var/jenkins_home/.ssh/known_hosts

# Start SSH agent and add key
docker compose exec jenkins bash -c "eval \$(ssh-agent -s) && ssh-add /var/jenkins_home/.ssh/id_rsa"

echo "Jenkins SSH setup complete!"
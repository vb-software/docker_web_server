#!/bin/bash

# Start Jenkins
# docker compose up jenkins -d

# # Wait for Jenkins to start
# echo "Waiting for Jenkins to start..."
# sleep 30

# Add GitHub's host key to known_hosts
docker compose exec jenkins bash -c "ssh-keyscan github.com >> /home/jenkins/.ssh/known_hosts"

# Ensure correct permissions for .ssh directory
docker compose exec jenkins bash -c "chmod 700 /home/jenkins/.ssh && chmod 600 /home/jenkins/.ssh/*"

echo "Jenkins setup complete!"
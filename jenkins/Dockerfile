# Use the official Jenkins LTS image as the base
FROM jenkins/jenkins:lts

# Switch to root to install additional packages
USER root

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Add Docker's official GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Create docker group
RUN groupadd -g 999 docker

# Create jenkins user with specific UID/GID if not already created
RUN groupadd -g 1000 jenkins || true && useradd -u 1000 -g jenkins -m jenkins || true

# Add jenkins user to docker group
RUN usermod -aG docker jenkins

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up permissions for Jenkins home and switch back to jenkins user
RUN mkdir -p /var/jenkins_home && chown -R jenkins:jenkins /var/jenkins_home
USER jenkins

# Set the work directory
WORKDIR /var/jenkins_home
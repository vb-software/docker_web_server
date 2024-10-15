FROM jenkins/jenkins:lts

USER root

# Install necessary packages
RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       ca-certificates \
                       curl \
                       gnupg2 \
                       software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Set up the Docker repository
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker-ce-cli

# Create the docker group and add jenkins to it
RUN groupadd docker && usermod -aG docker jenkins

# Create directory for .NET Core and set permissions
RUN mkdir -p /tmp/dotnet && chown jenkins:jenkins /tmp/dotnet

# Switch back to jenkins user
USER jenkins

# Jenkins runs on port 8080 by default, no need to expose it explicitly
FROM jenkins/jenkins:lts

USER root

# Install Docker dependencies
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Set up the Docker stable repository
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Add Jenkins user to Docker group
RUN usermod -aG docker jenkins

# Create a script to fix permissions at runtime
RUN echo '#!/bin/bash\n\
if [ "$JENKINS_UID" != "1000" ] || [ "$JENKINS_GID" != "1000" ]; then\n\
  groupmod -g $JENKINS_GID jenkins\n\
  usermod -u $JENKINS_UID -g $JENKINS_GID jenkins\n\
  chown -R jenkins:jenkins /var/jenkins_home\n\
fi\n\
exec su-exec jenkins /sbin/tini -- /usr/local/bin/jenkins.sh "$@"' > /usr/local/bin/jenkins-entrypoint.sh && \
    chmod +x /usr/local/bin/jenkins-entrypoint.sh

# Install su-exec
RUN apt-get update && apt-get install -y su-exec && rm -rf /var/lib/apt/lists/*

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/jenkins-entrypoint.sh"]
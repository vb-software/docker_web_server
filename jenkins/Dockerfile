FROM jenkins/jenkins:lts

USER root

# Install Docker
RUN apt-get update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install necessary tools
RUN apt-get update && apt-get install -y gettext-base

# Create docker group with same GID as host
COPY docker-setup.sh /usr/local/bin/docker-setup.sh
RUN chmod +x /usr/local/bin/docker-setup.sh

USER jenkins

ENTRYPOINT ["/usr/local/bin/docker-setup.sh"]
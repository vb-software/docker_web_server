# Use the official SonarQube Community Edition image as the base
FROM sonarqube:community

# Set the plugin version (adjust to the latest version)
ENV SONAR_BRANCH_PLUGIN_VERSION=1.22.0

# Download and install the community branch plugin
RUN mkdir -p $SONARQUBE_HOME/extensions/plugins/ && \
    curl -fSL -o $SONARQUBE_HOME/extensions/plugins/sonar-community-branch-plugin.jar \
    "https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${SONAR_BRANCH_PLUGIN_VERSION}/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar"

# Expose the SonarQube port
EXPOSE 9000

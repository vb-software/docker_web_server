# Use the official SonarQube Community Edition image as the base
FROM sonarqube:${SONARQUBE_VERSION}

# Set ARG for build-time variable
ARG SONAR_BRANCH_PLUGIN_VERSION

# Download and install the community branch plugin
RUN mkdir -p $SONARQUBE_HOME/extensions/plugins/ && \
    curl -fSL -o $SONARQUBE_HOME/extensions/plugins/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar \
    "https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${SONAR_BRANCH_PLUGIN_VERSION}/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar"

# Configure SonarQube to use the plugin
RUN echo "sonar.web.javaAdditionalOpts=-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar=web" >> $SONARQUBE_HOME/conf/sonar.properties && \
    echo "sonar.ce.javaAdditionalOpts=-javaagent:./extensions/plugins/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar=ce" >> $SONARQUBE_HOME/conf/sonar.properties

# Expose the SonarQube port
EXPOSE 9000

# Add a custom entrypoint script (if you're using one)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sonar"]
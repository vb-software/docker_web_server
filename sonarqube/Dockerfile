FROM sonarqube:community

ENV SONAR_BRANCH_PLUGIN_VERSION=1.22.0

USER root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/sonarqube/extensions/plugins/ && \
    curl -fSL -o /opt/sonarqube/extensions/plugins/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar \
    https://github.com/mc1arke/sonarqube-community-branch-plugin/releases/download/${SONAR_BRANCH_PLUGIN_VERSION}/sonarqube-community-branch-plugin-${SONAR_BRANCH_PLUGIN_VERSION}.jar

USER sonarqube
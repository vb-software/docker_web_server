#!/bin/bash
set -e

if [[ "${1:0:1}" = '-' ]]; then
  set -- sonar "$@"
fi

if [[ "$1" = 'sonar' ]]; then
  echo "Accepting third-party plugins..."
  touch $SONARQUBE_HOME/extensions/3rdparty-plugins.txt
  chown sonarqube:sonarqube $SONARQUBE_HOME/extensions/3rdparty-plugins.txt
fi

exec "$@"
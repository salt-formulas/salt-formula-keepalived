#!/bin/bash

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") /usr/bin/docker start jenkins
                  /usr/bin/docker start artifactory
                  exit 0
                  ;;
        "BACKUP") /usr/bin/docker stop jenkins
                  /usr/bin/docker stop artifactory
                  exit 0
                  ;;
        "FAULT")  /usr/bin/docker stop jenkins
                  /usr/bin/docker stop artifactory
                  exit 0
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
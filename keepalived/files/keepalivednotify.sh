#!/bin/bash
{%- set instance = salt['pillar.get']('keepalived:server:instance:'+instance_name) %}

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
        "MASTER") {{ instance.notify_action.master|indent(19, false) }}
                  ;;
        "BACKUP") {{ instance.notify_action.backup|indent(19, false) }}
                  ;;
        "FAULT")  {{ instance.notify_action.fault|indent(19, false) }}
                  ;;
        *)        echo "unknown state"
                  exit 1
                  ;;
esac
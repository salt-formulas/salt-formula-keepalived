#!/bin/bash -e

TYPE=$1
NAME=$2
STATE=$3

case $STATE in
    "MASTER")
        {%- for action in notify_action.master %}
        {{ action }}
        {%- endfor %}
        ;;
    "BACKUP")
        {%- for action in notify_action.backup %}
        {{ action }}
        {%- endfor %}
        ;;
    "FAULT")
        {%- for action in notify_action.fault %}
        {{ action }}
        {%- endfor %}
        ;;
    *)
      echo "Unknown state $STATE" 1>&2
      exit 1
      ;;
esac

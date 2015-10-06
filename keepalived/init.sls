
include:
{% if pillar.keepalived.cluster is defined %}
- keepalived.cluster
{% endif %}

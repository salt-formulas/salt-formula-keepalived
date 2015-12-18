
{%- if pillar.keepalived is defined %}
include:
{%- if pillar.keepalived.cluster is defined %}
- keepalived.cluster
{%- endif %}
{%- endif %}

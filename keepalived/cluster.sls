{% from "keepalived/map.jinja" import cluster with context %}

{%- if cluster.enabled %}

keepalived_packages:
  pkg.installed:
  - names: {{ cluster.pkgs }}

keepalived_config:
  file.managed:
  - name: {{ cluster.config }}
  - source: salt://keepalived/files/keepalived.conf
  - template: jinja
  - require:
    - pkg: keepalived_packages

{% for instance_name, instance in cluster.instance.iteritems() %}

{{%- if instance.notify_action is defined }}

keepalived_{{ instance_name }}_notify:
  file.managed:
  - name: /usr/local/bin/keepalivednotify_{{ instance_name }}.sh
  - mode: 744
  - source: salt://keepalived/files/keepalivednotify.sh
  - template: jinja
  - defaults:
      instance_name: {{ instance_name }}
  - require:
    - pkg: keepalived_packages
  - require_in:
    - service: keepalived_service

{%- endif %}

{% endfor %}

keepalived_service:
  service.running:
  - name: {{ cluster.service }}
  - enable: true
  - reload: true
  - watch:
    - file: keepalived_config

{%- endif %}
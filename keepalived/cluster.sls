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

keepalived_service:
  service.running:
  - name: {{ cluster.service }}
  - enable: true
  - reload: true
  - watch:
    - file: keepalived_config

{%- endif %}
{% from "keepalived/map.jinja" import cluster with context %}

{%- if cluster.enabled %}

keepalived_packages:
  pkg.installed:
  - names: {{ cluster.pkgs }}

{%- if pillar.collectd is defined %}
keepalived_packages_for_collectd:
  pkg.installed:
  - names: {{ cluster.collectd_pkgs }}
{%- endif %}

keepalived_config:
  file.managed:
  - name: {{ cluster.config }}
  - source: salt://keepalived/files/keepalived.conf
  - template: jinja
  - require:
    - pkg: keepalived_packages

{% for instance_name, instance in cluster.instance.iteritems() %}

{%- if instance.notify_action is defined %}

keepalived_{{ instance_name }}_notify:
  file.managed:
  - name: /usr/local/bin/keepalived_notify_{{ instance_name }}.sh
  - mode: 755
  - source: salt://keepalived/files/keepalived_notify.sh
  - template: jinja
  - defaults:
      notify_action: {{ instance.notify_action }}
  - require:
    - pkg: keepalived_packages
  - watch_in:
    - service: keepalived_service

{%- endif %}

{% endfor %}

{%- set _deployed = [] %}
{%- for name, script in cluster.get('vrrp_scripts', {}).iteritems() %}
{%- if script.get('name', name) not in _deployed %}keepalived_vrrp_script_{{ script.get('name', name) }}:{% else %}{% continue %}{% endif %}
{%- do _deployed.append(script.get('name', name)) %}
    file.managed:
    - name: /usr/local/bin/vrrp_script_{{ script.get('name', name) }}.sh
    - mode: 755
    - source:
      - salt://keepalived/files/vrrp_script_{{ script.get('name', name) }}.sh
      - salt://keepalived/files/vrrp_script.sh
    - template: jinja
    - defaults:
        script: {{ script|yaml }}
    - watch_in:
      - service: keepalived_service
{% endfor %}

keepalived_service:
  service.running:
  - name: {{ cluster.service }}
  - enable: true
  - reload: true
  {%- if grains.get('init', None) != 'systemd' %}
  - sig: keepalived
  {%- endif %}
  - watch:
    - file: keepalived_config

{%- endif %}

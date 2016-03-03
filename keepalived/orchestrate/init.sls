keepalived:
  salt.state:
    - tgt: 'roles:keepalived.*'
    - tgt_type: grain
    - sls: keepalived


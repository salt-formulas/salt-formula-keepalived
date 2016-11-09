keepalived:
  salt.state:
    - tgt: 'services:keepalived'
    - tgt_type: grain
    - sls: keepalived

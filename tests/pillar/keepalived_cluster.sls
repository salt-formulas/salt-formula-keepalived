keepalived:
  cluster:
    enabled: True
    instance:
      VIP0:
        priority: 100
        virtual_router_id: 10
        password: pass
        addresses:
        - 192.168.11.1
        - 192.168.11.2
        interface: eth0
      VIP1:
        priority: 100
        virtual_router_id: 11
        password: pass
        addresses:
        - 192.168.10.1
        - 192.168.10.2
        interface: eth0
        track_script: random_check
    vrrp_scripts:
      random_check:
        interval: 10
        content: |
          #!/bin/bash
          exit $(($RANDOM%2))


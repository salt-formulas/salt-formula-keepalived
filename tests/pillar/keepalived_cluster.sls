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
        track_script: check_random_exit
      VIP2:
        priority: 100
        virtual_router_id: 12
        password: pass
        addresses:
        - 192.168.12.1
        - 192.168.12.2
        interface: eth0
        track_script: check_haproxy
      VIP3:
        priority: 100
        virtual_router_id: 13
        password: pass
        addresses:
        - 192.168.13.1
        - 192.168.13.2
        interface: eth0
        track_script:
          check_haproxy:
            interval: 10
          check_mysql_cluster:
            weight: 50
      VIP4:
        priority: 100
        virtual_router_id: 14
        password: pass
        addresses:
        - 192.168.14.1
        - 192.168.14.2
        interface: eth0
        track_script:
          check_haproxy: None
          check_ssh_port:
            weight: 50
    vrrp_scripts:
      check_ssh_port:
        name: check_port
        args: "22"
      check_mysql_cluster:
        args:
          - clustercheck
          - clustercheck
          - available_when_donor=0
          - available_when_readonly=0
      check_haproxy:
        name: check_pidof
        args: haproxy
      check_haproxy2:
        name: check_pidof
        args:
          - haproxy
      check_random_exit:
        interval: 10
        content: |
          #!/bin/bash
          exit $(($RANDOM%2))


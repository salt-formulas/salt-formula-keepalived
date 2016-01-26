keepalived:
  cluster:
    enabled: True
    instance:
      VIP1:
        priority: 100 
        virtual_router_id: 51
        password: pass
        addresses:
        - 192.168.10.1
        - 192.168.10.2
        interface: eth0


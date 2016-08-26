==========
Keepalived
==========

Keepalived is a routing software written in C. The main goal of this project is to provide simple and robust facilities for loadbalancing and high-availability to Linux system and Linux based infrastructures. Loadbalancing framework relies on well-known and widely used Linux Virtual Server (IPVS) kernel module providing Layer4 loadbalancing. Keepalived implements a set of checkers to dynamically and adaptively maintain and manage loadbalanced server pool according their health. On the other hand high-availability is achieved by VRRP protocol. VRRP is a fundamental brick for router failover. In addition, Keepalived implements a set of hooks to the VRRP finite state machine providing low-level and high-speed protocol interactions. Keepalived frameworks can be used independently or all together to provide resilient infrastructures.


Sample pillar
=============

Simple virtual IP on an interface

.. code-block:: yaml

    keepalived:
      cluster:
        enabled: True
        instance:
          VIP1:
            nopreempt: True
            priority: 100 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 51
            password: pass
            address: 192.168.10.1
            interface: eth0
          VIP2:
            nopreempt: True
            priority: 150 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 52
            password: pass
            address: 10.0.0.5
            interface: eth1

Multiple virtual IPs on single interface

.. code-block:: yaml

    keepalived:
      cluster:
        enabled: True
        instance:
          VIP1:
            nopreempt: True
            priority: 100 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 51
            password: pass
            addresses:
            - 192.168.10.1
            - 192.168.10.2
            interface: eth0

Disable nopreempt mode to have Master. Highest priority is taken in all cases.

.. code-block:: yaml

    keepalived:
      cluster:
        enabled: True
        instance:
          VIP1:
            nopreempt: False
            priority: 100 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 51
            password: pass
            addresses:
            - 192.168.10.1
            - 192.168.10.2
            interface: eth0

Notify action in keepalived.

.. code-block:: yaml

    keepalived:
      cluster:
        enabled: True
        instance:
          VIP1:
            nopreempt: True
            notify_action: 
              master: |
                /usr/bin/docker start jenkins
                /usr/bin/docker start gerrit
                exit 0
              backup: |
                /usr/bin/docker stop jenkins
                /usr/bin/docker stop gerrit
                exit 0
              fault: |
                /usr/bin/docker stop jenkins
                /usr/bin/docker stop gerrit
                exit 0
            priority: 100 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 51
            password: pass
            addresses:
            - 192.168.10.1
            - 192.168.10.2
            interface: eth0

Read more
=========

* https://raymii.org/s/tutorials/Keepalived-Simple-IP-failover-on-Ubuntu.html

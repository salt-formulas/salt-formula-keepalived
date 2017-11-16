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
            auth_type: AH
            password: pass
            address: 192.168.10.1
            interface: eth0
          VIP2:
            nopreempt: True
            priority: 150 (highest priority must be on primary server, different for cluster members)
            virtual_router_id: 52
            auth_type: PASS
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


Use unicast

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
            unicast_src_ip: 172.16.10.1
            unicast_peer:
              172.16.10.2
              172.16.10.3


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
              master:
                - /usr/bin/docker start jenkins
                - /usr/bin/docker start gerrit
              backup:
                - /usr/bin/docker stop jenkins
                - /usr/bin/docker stop gerrit
              fault:
                - /usr/bin/docker stop jenkins
                - /usr/bin/docker stop gerrit
            priority: 100 # highest priority must be on primary server, different for cluster members
            virtual_router_id: 51
            password: pass
            addresses:
            - 192.168.10.1
            - 192.168.10.2
            interface: eth0

Track/vrrp scripts for keepalived instance:

.. code-block:: yaml

    keepalived:
      cluster:
        enabled: True
        instance:
          VIP2:
            priority: 100
            virtual_router_id: 10
            password: pass
            addresses:
            - 192.168.11.1
            - 192.168.11.2
            interface: eth0
            track_script: check_haproxy
          VIP3:
            priority: 100
            virtual_router_id: 11
            password: pass
            addresses:
            - 192.168.10.1
            - 192.168.10.2
            interface: eth0
            track_script:
              check_random_exit:
                interval: 10
              check_port:
                weight: 50
        vrrp_scripts:
          check_haproxy:
            name: check_pidof
            args:
              - haproxy
          check_mysql_port:
            name: check_port
            args:
              - 3306
              - TCP
              - 4
          check_ssh:
            name: check_port
            args: "22"
          check_mysql_cluster:
            args:
              # github: olafz/percona-clustercheck
              # <user> <pass> <available_when_donor=0|1> <log_file> <available_when_readonly=0|1> <defaults_extra_file>
              - clustercheck
              - clustercheck
              - available_when_donor=0
              - available_when_readonly=0
          check_random_exit:
            interval: 10
            content: |
              #!/bin/bash
              exit $(($RANDOM%2))
            weight: 50


Read more
=========

* https://raymii.org/s/tutorials/Keepalived-Simple-IP-failover-on-Ubuntu.html

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-keepalived/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-keepalived

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net

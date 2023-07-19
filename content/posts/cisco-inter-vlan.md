---
title: "Cisco - Inter-VLAN Routing (Router on a Stick)"
date: 2023-06-16T10:41:05+08:00
draft: false
author: "King Tam"
summary: "Cisco - Inter-VLAN Routing (Router on a Stick)" 
showToc: true
categories:
- Network
tags:
- cisco
- vlan
- router
- switch
- inter-vlan
ShowLastMod: true
cover:
    image: "img/cisco-inter-vlan/cisco-inter-vlan.jpg"
---



### Introduction:

> `Inter-VLAN Routing` means enabling communication between originally isolated `vlans`, and `Router on a Stick` (also called single-arm routing) refers to implementing `vlan` communication on a single port of a router.

---

### Objective:

> Configure multiple `vlan` groups on a single router port and enable communication between different `vlans`.

---

### Simulation Scenario:

![Diagram_2021-09-18_095748](/img/cisco-inter-vlan/Diagram_2021-09-18_095748.png)

| vLan   | IP(Subnet)    |
| ------ | ------------- |
| vlan10 | 10.10.10.0/24 |
| vlan20 | 10.10.20.0/24 |

> PC1 is in vlan10, PC2 is in vlan20, the IPs of the two computers are in different segments, and the router settings allow PC1 and PC2 to communicate with each other.

---

### Router Settings (Cisco 2901)

![Router_2021-09-18_092543](/img/cisco-inter-vlan/Router_2021-09-18_092543.png)

~~~ruby
Router>enable
Router#configure terminal
~~~

> Enter `Global Configuration Mode`

~~~ruby
Router(config)#interface gigabitEthernet 0/1
Router(config-if)#no shutdown
Router(config-if)#exit
~~~

> Select physical port 0/1 and enable it

~~~ruby
Router(config)#interface gigabitEthernet 0/1.10
Router(config-subif)#encapsulation dot1Q 10
Router(config-subif)#ip address 10.10.10.1 255.255.255.0
Router(config-subif)#exit
~~~

> Configure sub-interface on physical port 0/1
>
> Configure 802.1Q protocol and assign vlan10
>
> Set the IP address of the interface

~~~ruby
Router(config)#interface gigabitEthernet 0/1.20
Router(config-subif)#encapsulation dot1Q 20
Router(config-subif)#ip address 10.10.20.1 255.255.255.0
Router(config-subif)#end
~~~

> Configure sub-interface on physical port 0/1
>
> Configure 802.1Q protocol and assign vlan20
>
> Set the IP address of the interface

~~~ruby
Router#write memory
~~~

> Save the configuration



---

#### DHCP Server Setup on the Router

![Router_DHCP_2021-09-18_094946](/img/cisco-inter-vlan/Router_DHCP_2021-09-18_094946.png)

~~~ruby
Router>enable
Router#configure terminal
~~~

> Enter `Global Configuration Mode`

~~~ruby
Router(config)#ip dhcp excluded-address 10.10.10.1 10.10.10.50
Router(config)#ip dhcp pool dhcp.vlan10
Router(dhcp-config)#default-router 10.10.10.1
Router(dhcp-config)#network 10.10.10.0 255.255.255.0
Router(dhcp-config)#dns-server 1.1.1.1
Router(dhcp-config)#exit
~~~

> 10.10.10.1 - 10.10.10.50 are reserved IP address segments, not assigned to devices.
>
> Create an address allocation pool named dhcp.vlan10
>
> Default router IP address 10.10.10.1
>
> Network segment is 10.10.10.0/24
>
> DNS server is 1.1.1.1

~~~ruby
Router(config)#ip dhcp excluded-address 10.10.20.1 10.10.20.50
Router(config)#ip dhcp pool dhcp.vlan20
Router(dhcp-config)#default-router 10.10.20.1
Router(dhcp-config)#network 10.10.20.0 255.255.255.0
Router(dhcp-config)#dns-server 1.1.1.1
Router(dhcp-config)#exit
~~~

> 10.10.20.1 - 10.10.20.50 are reserved IP address segments, not assigned to devices.
>
> > Create an address allocation pool named dhcp.vlan20
>
> Default router IP address 10.10.20.1
>
> Network segment is 10.10.20.0/24
>
> DNS server is 1.1.1.1

~~~ruby
Router(config)#end
Router#write memory
~~~

> Save the configuration

---

### Switch Settings (Cisco 2960)

![Switch_2021-09-18_091732](/img/cisco-inter-vlan/Switch_2021-09-18_091732.png)

~~~ruby
Switch>enable
Switch#configure terminal
~~~

> Enter `Global Configuration Mode`

~~~ruby
Switch(config)#vlan 10
Switch(config-vlan)#name vlan10
Switch(config-vlan)#exit
~~~

> Create and name vlan10

~~~ruby
Switch(config)#vlan 20
Switch(config-vlan)#name vlan20
Switch(config-vlan)#exit
~~~

> Create and name vlan20

~~~ruby
Switch(config)#interface fastEthernet 0/1
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 10
Switch(config-if)#exit
~~~

> Configure port 0/1 in access mode and assign it to vlan10

~~~ruby
Switch(config)#interface fastEthernet 0/2
Switch(config-if)#switchport mode access
Switch(config-if)#switchport access vlan 20
Switch(config-if)#exit
~~~

> Configure port 0/2 in access mode and assign it to vlan20

~~~ruby
Switch(config)#interface fastEthernet 0/24
Switch(config-if)#switchport mode trunk
Switch(config-if)#exit
~~~

> Configure port 0/24 in trunk mode to connect to the router

~~~ruby
Switch(config)#end
Switch#write memory
~~~

> Save the configuration

---



### Test Connectivity

> Connect **PC1** to `FastEthernet 0/1` and **PC2** to `FastEthernet 0/5` on the switch.
> Connect the **router's** `GigabitEthernet 0/1` port to the **switch's** `GigabitEthernet 0/1` port.
> Set **PC1** and **PC2** to obtain IP addresses automatically. They should receive IP addresses from their respective DHCP pools.

![2021-09-18_095342](/img/cisco-inter-vlan/2021-09-18_095342.png)

PC1 is assigned the IP address 10.10.10.51 (vlan10 network segment)

![2021-09-18_095352](/img/cisco-inter-vlan/2021-09-18_095352.png)

PC2 is assigned the IP address 10.10.20.51 (vlan20 network segment)



![2021-09-18_095534](/img/cisco-inter-vlan/2021-09-18_095534.png)

![2021-09-18_095519](/img/cisco-inter-vlan/2021-09-18_095519.png)

Test connectivity between PC1 and PC2 by using the `ping` command.

---

### Conclusion:

> We be able to successfully send and receive packets between PC1 and PC2, even though they are on different VLANs. This demonstrates successful inter-VLAN communication using the Router on a Stick method.



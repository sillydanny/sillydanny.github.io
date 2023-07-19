---
title: "Cisco - DHCP Relay Agent (IP Helper)"
date: 2023-06-15T11:05:07+08:00
draft: false
author: "King Tam"
summary: "Cisco - DHCP Relay Agent (IP Helper)" 
showToc: true
categories:
- Network
tags:
- cisco
- IP Helper
- DHCP Relay Agent
- switch
- router
- vlan
ShowLastMod: true
cover:
    image: "img/cisco-ip-helper/cisco-ip-helper.jpg"
---

### About

> `DHCP Relay Agent` is the bridge between the client and the DHCP server. Through the `DHCP Relay Agent`, clients' broadcasts can be received across different network segments, allowing the DHCP server to successfully assign IP addresses to clients.

---

### Infrastructure

> Configure multiple `vlan` groups on a single router interface and assign IP addresses through the DHCP server across different `vlan` groups.

![2021-09-20_150745](/img/cisco-ip-helper/2021-09-20_150745.png)

| vLan   | IP(Subnet)      |
| ------ | --------------- |
| vlan10 | 192.168.10.0/24 |
| vlan20 | 192.168.20.0/24 |
| vlan30 | 192.168.30.0/24 |
| vlan40 | 192.168.40.0/24 |

> PC1 in vlan10
>
> PC2 in vlan20
>
> PC3 in vlan30
>
> PC0 in vlan40
>
> DHCP Server (192.168.40.254) in vlan40, clients in all vlan (10, 20, 30, 40) can obtain IP addresses through the DHCP Server in vlan40.

---

### DHCP Server Configuration

![2021-09-20_150603](/img/cisco-ip-helper/2021-09-20_150603.png)

Set IP address to 192.168.40.254

![2021-09-20_150616](/img/cisco-ip-helper/2021-09-20_150616.png)

Create 4 DHCP address pools corresponding to Vlan 10, Vlan 20, Vlan 30, and Vlan 40.



---



### Router Configuration (Cisco 2911)

![2021-09-20_142815](/img/cisco-ip-helper/2021-09-20_142815.png)

~~~ruby
Router>enable
Router#configure terminal
~~~

> Enter `Global Configuration Mode`

~~~ruby
Router(config)#interface gigabitEthernet 0/0
Router(config-if)#no shutdown
Router(config-if)#exit
~~~

> Select physical interface 0/0 and enable it

~~~ruby
Router(config)#interface gigabitEthernet 0/0.10
Router(config-subif)#encapsulation dot1Q 10
Router(config-subif)#ip address 192.168.10.1 255.255.255.0
Router(config-subif)#exit
~~~

> Configure sub-interface on physical interface 0/0
>
> Configure 802.1Q protocol and assign `vlan10`
>
> Set interface IP address `ip address 192.168.10.1 255.255.255.0`

~~~ruby
Router(config)#interface gigabitEthernet 0/0.20
Router(config-subif)#encapsulation dot1Q 20
Router(config-subif)#ip address 192.168.20.1 255.255.255.0
Router(config-subif)#end
~~~

> Configure sub-interface on physical interface 0/0
>
> Configure 802.1Q protocol and assign `vlan20`
>
> Set interface IP address `ip address 192.168.20.1 255.255.255.0`

~~~ruby
Router(config)#interface gigabitEthernet 0/0.30
Router(config-subif)#encapsulation dot1Q 20
Router(config-subif)#ip address 192.168.30.1 255.255.255.0
Router(config-subif)#end
~~~

> Configure sub-interface on physical interface 0/0
>
> Configure 802.1Q protocol and assign `vlan30`
>
> Set interface IP address `ip address 192.168.30.1 255.255.255.0`

~~~ruby
Router(config)#interface gigabitEthernet 0/0.40
Router(config-subif)#encapsulation dot1Q 40
Router(config-subif)#ip address 192.168.40.1 255.255.255.0
Router(config-subif)#end
~~~

> Configure sub-interface on physical interface 0/0
>
> Configure 802.1Q protocol and assign `vlan40`
>
> Set interface IP address `ip address 192.168.40.1 255.255.255.0`

---

### Configure IP Helper (DHCP Relay Agent)

~~~ruby
Router(config)#interface gigabitEthernet 0/0.10
Router(config-subif)#ip helper-address 192.168.40.254
Router(config-subif)#exit
~~~

> Add the IP Helper (DHCP Relay Agent) to sub-interface 0/0.10, pointing to the DHCP Server at 192.168.40.254

~~~ruby
Router(config)#interface gigabitEthernet 0/0.20
Router(config-subif)#ip helper-address 192.168.40.254
Router(config-subif)#exit
~~~

> Add the IP Helper (DHCP Relay Agent) to sub-interface 0/0.20, pointing to the DHCP Server at 192.168.40.254

~~~ruby
Router(config)#interface gigabitEthernet 0/0.30
Router(config-subif)#ip helper-address 192.168.40.254
Router(config-subif)#exit
~~~

> Add the IP Helper (DHCP Relay Agent) to sub-interface 0/0.30, pointing to the DHCP Server at 192.168.40.254

~~~ruby
Router(config)#interface gigabitEthernet 0/0.40
Router(config-subif)#ip helper-address 192.168.40.254
Router(config-subif)#exit
~~~

> Add the IP Helper (DHCP Relay Agent) to sub-interface 0/0.40, pointing to the DHCP Server at 192.168.40.254



~~~ruby
Router(dhcp-config)#end
Router#write
~~~

> Save


---

### Switch Settings (Cisco 2960-24T)

#### <u>**Switch1**</u>

![2021-09-20_143633](/img/cisco-ip-helper/2021-09-20_143633.png)



~~~ruby
Switch>enable
Switch#configure terminal
~~~

> Enter `Global Configuration Mode` mode

~~~ruby
Switch(config)#vlan 10
Switch(config-vlan)#vlan 20
Switch(config-vlan)#vlan 30
Switch(config-vlan)#vlan 40
Switch(config-vlan)#exit
~~~

> Create 4 VLANs

~~~ruby
Switch(config)#interface range gigabitEthernet 0/1-2
Switch(config-if-range)#switchport mode trunk
Switch(config-if-range)#exit
~~~

> Define ports g0/1 and g0/2 as Trunk mode (*all VLAN data is transmitted through this interface to the client device)

~~~ruby
Switch(config)#interface range fastEthernet 0/1-10
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 10
Switch(config-if-range)#exit
~~~

> Assign ports f0/1-10 to Vlan10

~~~ruby
Switch(config)#interface range fastEthernet 0/11-20
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 20
Switch(config-if-range)#end
~~~

> Assign ports f0/11-20 to Vlan20

~~~ruby
Switch#write
~~~

> Save

#### <u>**Switch2**</u>

![2021-09-20_143942](/img/cisco-ip-helper/2021-09-20_143942.png)


~~~ruby
Switch>enable
Switch#configure terminal
~~~

> Enter `Global Configuration Mode` mode

~~~ruby
Switch(config)#vlan 10
Switch(config-vlan)#vlan 20
Switch(config-vlan)#vlan 30
Switch(config-vlan)#vlan 40
Switch(config-vlan)#exit
~~~

> Create 4 VLANs

~~~ruby
Switch(config)#interface range gigabitEthernet 0/2
Switch(config-if)#switchport mode trunk
Switch(config-if)#exit
~~~

> Define port g0/2 as Trunk mode (* connect to port g0/2 of Switch1)

~~~ruby
Switch(config)#interface range fastEthernet 0/1-10,f0/24
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 40
Switch(config-if-range)#exit
~~~

> Assign ports f0/1-10 and f0/24 to Vlan40

~~~ruby
Switch(config)#interface range fastEthernet 0/11-20
Switch(config-if-range)#switchport mode access
Switch(config-if-range)#switchport access vlan 30
Switch(config-if-range)#end
~~~

> Assign ports f0/11-20 to Vlan30

~~~ruby
Switch#write
~~~

> Save


---

### Test DHCP IP Assignment

> Now, we can test the DHCP IP assignment by setting the PCs in each VLAN to obtain IP addresses automatically.
>
> If the configuration is correct, they should receive IP addresses within their respective VLANs' IP ranges from the DHCP Server.

![2021-09-20_144411](/img/cisco-ip-helper/2021-09-20_144411.png)

The IP address assigned to PC1 is 192.168.10.11 (vlan10 network segment)

![2021-09-20_144416](/img/cisco-ip-helper/2021-09-20_144416.png)

The IP address assigned to PC2 is 192.168.20.10 (vlan20 network segment)

![2021-09-20_144423](/img/cisco-ip-helper/2021-09-20_144423.png)

The IP address assigned to PC3 is 192.168.30.10 (vlan30 network segment)

![2021-09-20_144433](/img/cisco-ip-helper/2021-09-20_144433.png)

The IP address assigned to PC0 is 192.168.40.11 (vlan40 network segment)



![2021-09-20_144554](/img/cisco-ip-helper/2021-09-20_144554.png)

PC1 Ping PC2, PC3, PC0 (can communicate with each other)

---

### Conclusion:

> In this example configuration, the PCs in vlan10, vlan20, vlan30, and vlan40 have successfully obtained IP addresses from the DHCP Server in vlan40. The IP Helper (DHCP Relay Agent) has successfully helped in relaying the DHCP requests and responses between the clients and the DHCP server across different VLANs.

---
title: "Cisco - Router Connect to the Internet"
date: 2023-06-16T13:46:58+08:00
draft: false
author: "King Tam"
summary: "Cisco - Router Connect to the Internet" 
showToc: true
categories:
- Network
tags:
- cisco
- router
- internet
ShowLastMod: true
cover:
    image: "img/cisco-router-internet/cisco-router-internet.jpg"
---


![Cover_2021-11-08_104518](/img/cisco-router-internet/Cover_2021-11-08_104518-1686893780393.png)

### Introduction:

> This is a basic network configuration guide for Cisco routers, and all exercises are based on a simulator (EVE-NG).

---

<span id='ip'></span>

### Enable and Configure Port IP Addresses

> In this example, `interface Ethernet0/0` is the `LAN` port, and `interface Ethernet0/1` is the `WAN` port.

![2021-11-08_095949](/img/cisco-router-internet/2021-11-08_095949-1686893780394.png)

~~~ruby
Router#enable
Router#
Router#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#
Router(config)#interface e0/1
Router(config-if)#ip address 19.86.11.96 255.255.255.0
Router(config-if)#no shutdown
Router(config-if)#exit
Router(config)#
Router(config)#interface e0/0
Router(config-if)#ip address 17.16.1.1 255.255.255.0
Router(config-if)#no shutdown
Router(config-if)#end
~~~

---

#### Check IP Addresses for Port

![2021-11-08_100025](/img/cisco-router-internet/2021-11-08_100025-1686893780394.png)

~~~ruby
Router#show ip interface brief
~~~

> Interface                  IP-Address      OK? Method Status                Protocol
> Ethernet0/0                17.16.1.1       YES manual up                    up
> Ethernet0/1                19.86.11.96     YES manual up                    up

---

<span id='dhcp'></span>

### Configure DHCP Server

> Each device that connects to the Internet needs a unique IP address. DHCP enables network administrators to monitor and allocate IP addresses from a central node. When a computer is moved to another location on the network, it can automatically receive a new IP address. From [Wiki](https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E4%B8%BB%E6%9C%BA%E8%AE%BE%E7%BD%AE%E5%8D%8F%E8%AE%AE)

![2021-11-08_100227](/img/cisco-router-internet/2021-11-08_100227-1686893780394.png)

~~~ruby
Router#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#
Router(config)#ip dhcp excl
Router(config)#ip dhcp excluded-address 17.16.1.1 17.16.1.50
Router(config)#
Router(config)#ip dhcp pool LAN
Router(dhcp-config)#network 17.16.1.0 255.255.255.0
Router(dhcp-config)#default-router 17.16.1.1
Router(dhcp-config)#dns-server 1.1.1.1
Router(dhcp-config)#end
~~~

---

#### Test with Client Computers:

![2021-11-08_102824](/img/cisco-router-internet/2021-11-08_102824-1686893780394.png)

![2021-11-08_102850](/img/cisco-router-internet/2021-11-08_102850-1686893780394.png)

---

<span id='nat'></span>

### `NAT`(Network Address Translation)

> Simply put, all devices on the internal network share one external IP address. This is a technology that rewrites the source IP address or destination IP address of IP packets when they pass through a router or firewall. From: [Wiki](https://zh.wikipedia.org/wiki/%E7%BD%91%E7%BB%9C%E5%9C%B0%E5%9D%80%E8%BD%AC%E6%8D%A2)

![2021-11-08_101952](/img/cisco-router-internet/2021-11-08_101952-1686893780394.png)

~~~ruby
Router#enable
Router#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#int e0/0
Router(config-if)#ip nat inside
Router(config-if)#exit
Router(config)#int e0/1
Router(config-if)#ip nat outside
Router(config-if)#exit
Router(config)#
Router(config)#
Router(config)#access-list 1 permit 17.16.1.0 0.0.0.255
Router(config)#
Router(config)#ip nat inside source list 1 interface ethernet 0/1 overload
Router(config)#end
~~~

---

<span id='route'></span>



### Route

> A router is a networking device that forwards data packets between computer networks. Routers perform the traffic directing functions on the Internet. From [Wiki](https://en.wikipedia.org/wiki/Router_(computing))

#### Default Route Configuration

> A default route is a route that is used by a router when no other known route exists for a given IP address destination.

![2021-11-08_102115 - Route](/img/cisco-router-internet/2021-11-08_102115_Route.png)

~~~ruby
Router#enable
Router#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#
Router(config)#ip route 0.0.0.0 0.0.0.0 19.86.11.1
Router(config)#end
~~~

#### Check Routes:

~~~ruby
Router#show ip route
~~~


#### Internet Connection Test:

![2021-11-08_103014](/img/cisco-router-internet/2021-11-08_103014-1686893780394.png)

---

### Port-Forwarding

> Port forwarding is a technique that is used to allow external devices access to a specific computer or service within a private local-area network (LAN). It is done by mapping a public IP address to a private IP address and specific port number. From [Wiki](https://en.wikipedia.org/wiki/Port_forwarding)

#### Configuration

> In this example, we use port 3389 of Remote Desktop to access the computer (Windows7) with IP address 17.16.1.51 in the internal network.


~~~ruby
Router#enable
Router#configure terminal
Enter configuration commands, one per line.  End with CNTL/Z.
Router(config)#
Router(config)#ip nat inside source static tcp 17.16.1.51 3389 19.86.11.96 3389
Router(config)#exit
~~~

#### Check with Test


![2021-11-08_103600](/img/cisco-router-internet/2021-11-08_103600-1686893780394.png)

![2021-11-08_103611](/img/cisco-router-internet/2021-11-08_103611-1686893780394.png)

![2021-11-08_103648](/img/cisco-router-internet/2021-11-08_103648-1686893780394.png)

---

#### Finally, remember to "save" all settings

![2021-11-08_102115 - Save](/img/cisco-router-internet/2021-11-08_102115.png)

~~~ruby
Router#write memory
Building configuration...
[OK]
~~~

---

### Conclusion:

> Compared with home routers, setting up Cisco routers is more cumbersome because home routers already have default `WAN` and `LAN (bridge)` settings, while Cisco routers are based on commercial use, and each configuration step requires a deeper understanding of the network.

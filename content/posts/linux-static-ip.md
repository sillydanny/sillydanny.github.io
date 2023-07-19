---
title: "Setting a static IP address in Linux"
date: 2023-06-02T12:16:06+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Linux
tags:
- static
- IP
- vlan
- bridge
- interface
ShowLastMod: true
cover:
    image: "img/linux-static-ip/linux-static-ip.jpg"
---

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Introduction:</b> </font></td></tr></table>

> Usually, IP addresses are dynamically assigned by the router's DHCP server on most network devices. But using a static IP address on the server makes the provided services more stable. If the DHCP server is not working, it will affect the computers in the local area network to obtain IP addresses, thereby affecting access to services, while servers with static IP addresses are not affected, so static IP is also necessary (on devices providing services).

---

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Table of Contents:</b> </font></td></tr></table>

1. [Configuring a static IP address in RHEL/CentOS/Fedora:](#1)
2. [Setting a static IP address in Debian / Ubuntu (versions prior to 17.10):](#2)
3. [Setting a static IP address in Ubuntu (newer versions):](#3)
4. [Setting up VLAN in Ubuntu:](#4)
5. [Setting up Bridge in Debian:](#5)
   - [Bridge without VLAN](#5.1)
   - [Bridge with VLAN](#5.2)



<span id="1"></span>


<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Configuring a static IP address in RHEL/CentOS/Fedora:</b> </font></td></tr></table>

To set a static IP address in **RHEL** / **CentOS** / **Fedora**

First check the local network interface name:

![2022-03-18_121212](/img/linux-static-ip/2022-03-18_121212.png)

The above figure shows that the network interface name of the local machine is `eth0`, representing the edited network file `ifcfg-eth0`

Use nano or vim to edit:

```bash
vim /etc/sysconfig/network-scripts/ifcfg-eth0
```

Make changes to the `ifcfg-eth0` file based on your own network:

```bash
DEVICE="eth0"
BOOTPROTO="static"
DNS1="8.8.8.8"
DNS2="1.1.1.1"
GATEWAY="192.168.0.1"
HOSTNAME="linux.kingtam.win"
HWADDR="00:19:99:A4:46:AB"
IPADDR="192.68.0.100"
NETMASK="255.255.255.0"
NM_CONTROLLED="yes"
ONBOOT="yes"
TYPE="Ethernet"
UUID="8105c095-799b-4f5a-a445-c6d7c3681f07"
```


You need to edit the following settings:

- BOOTPROTO is `dhcp` (default) or `static` (static)
- DNS1 and DNS2 can use public DNS services such as 8.8.8.8, 1.1.1.1
- Gateway (GATEWAY) is the IP of the router or firewall
- Host name (HOSTNAME) customizable
- Network mask (NETMASK) is usually 255.255.255.0 (/24) modify according to your own network parameters
- IP address (IPADDR) the local IP address
- ONBOOT whether to start automatically is `yes` or `no`


Then edit: `resolve.conf`

> `resolve.conf` is used to set the definitions of each item when the DNS client requests name resolution.

```bash
vim /etc/resolv.conf
```

```bash
nameserver 8.8.8.8 # Modify with your preferred DNS address
nameserver 1.1.1.1 # Modify with your preferred DNS address
```

Use one of the following commands to restart the network and apply all settings:

```bash
/etc/init.d/network restart
```

```bash
systemctl restart network
```



<span id="2"></span>


<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Setting a static IP address in Debian / Ubuntu (versions prior to 17.10):</b> </font></td></tr></table>

To set a static IP address in **Debian**/**Ubuntu** (versions prior to 17.10), open the following file:

```bash
vim /etc/network/interfaces
```

The default is `dhcp`:

```bash
 no-auto-down eth0 # or possibly auto eth0
 iface eth0 inet dhcp
```

Edit using nano or vim, and make changes based on your own network:

```bash
no-auto-down eth0
iface eth0 inet static
  address 192.168.0.100
  netmask 255.255.255.0
  gateway 192.168.0.1
  dns-nameservers 1.1.1.1
  dns-nameservers 8.8.8.8
```

The following settings need to be edited:

- Change `iface eth0 inet dhcp` (default) to `iface eth0 inet static` (static)
- `dns-nameservers` can have multiple values, such as using public DNS services like `8.8.8.8`, `1.1.1.1`
- `gateway` is the IP address of the router or firewall
- `netmask` is usually 255.255.255.0 (/24), adjust according to your own network parameters
- `address` is the IP address of the local machine

After saving the `interfaces` settings, edit `/etc/resolv.conf`:

```bash
vim /etc/resolv.conf
nameserver 8.8.8.8 # Modify with your preferred DNS address
nameserver 1.1.1.1 # Modify with your preferred DNS address
```

Use one of the following commands to restart the network and apply all settings:


```bash
/etc/init.d/network restart
```

```bash
systemctl restart network
```



<span id="3"></span>


<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Setting a static IP address in Ubuntu (newer versions):</b> </font></td></tr></table>

> Starting from Ubuntu 17.10, [Netplan](https://netplan.io/) is the default network management tool.

Network configuration files are stored in `*.yaml` files in the directory `/etc/netplan/`.

In my case, it is `/etc/netplan/00-installer-config.yaml`, and the default content is:

```bash
network:
  ethernets:
    eth0:
      dhcp4: true
  version: 2
```

Edit the `00-installer-config.yaml` configuration file using nano or vim:

```bash
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
     dhcp4: no
     addresses: [192.168.1.2/24]
     routes:
      - to: default
        via: 192.168.1.1
     nameservers:
       addresses: [8.8.8.8,1.1.1.1]
```

You need to edit the following settings:

- `renderer: networkd` specifies that this interface is managed by the `systemd-networkd` service
- `dhcp4: no` changes to manual static IP address setup
- `addresses` the local IP address and network segment
- `nameservers` DNS server
  - `addresses` [8.8.8.8,1.1.1.1] can be multiple IP addresses

Save the `00-installer-config.yaml` settings.

Apply the network settings using the following command:

```
netplan apply
```

<span id="vlan"></span>

<span id="4"></span>

---

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Setting up VLAN in Ubuntu:</b> </font></td></tr></table>

> In this example, N1 is flashed with Armbian, and the network port is connected to the trunk port of the switch.

### Dynamically obtain an IP address

The network configuration files are stored in `*.yaml` files in the `/etc/netplan/` directory.

The default content of `/etc/netplan/armbian-default.yaml` is:

```bash
network:
  version: 2
  renderer: NetworkManager
```

Edit the `/etc/netplan/armbian-default.yaml` configuration file using nano or vim:

```yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
      eth0:
          dhcp4: true
  vlans:
      vlan.3:
          id: 3
          link: eth0
          dhcp4: true
```

The configuration file is written in YAML format, and various settings are included:

- The "version: 2" in the first line specifies the YAML version used in this file.

- The "renderer" field specifies the network management tool to be used, which in this case is "NetworkManager", a popular tool for managing networks on Linux systems.

- In the "ethernets" section, the "eth0" physical interface is configured, and the interface is set to obtain an IPv4 address via DHCP.

- In the "vlans" section, the VLAN (Virtual Local Area Network) interface on the "eth0" network interface is configured. The VLAN ID is 3 and is connected to the physical interface "eth0" via the "link" field. The VLAN interface is also configured to obtain an IPv4 address via DHCP.

  > This configuration file sets up a network connection where both the physical interface "eth0" and the VLAN interface obtain dynamic IP addresses via DHCP.

---


### Set static IP address

~~~yaml
  version: 2
  renderer: NetworkManager
  ethernets:
      eth0:
        dhcp4: false
  vlans:
      vlan.3:
          id: 3
          link: eth0
          dhcp4: no
          addresses: [10.3.3.3/24]
          routes:
           - to: default
             via: 10.3.3.1
          nameservers:
            addresses: [8.8.8.8,1.1.1.1]
~~~


> The VLAN configuration sets up a new interface vlan.3 with ID 3 associated with eth0. Its dhcp4 is set to no, with the static IP address 10.3.3.3 and subnet mask 24. The default route is specified through IP address 10.3.3.1, and 8.8.8.8 and 1.1.1.1 are set as DNS servers.



<span id="5"></span>

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Setting up Bridge  in Debian:</b> </font></td></tr></table>

<span id="5.1"></span>

<mark>**Without VLAN**</mark>

To find out the default network interface name of the machine, use the following command:

~~~bash
ip -c route | head -n 1 | cut -d ' ' -f 5
~~~

> eth0

Edit the network interface via text editor

~~~bash
sudo vim  /etc/network/interfaces
~~~

**<u>i.</u>** As **DHCP**:

~~~yaml
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# Wired adapter #1
allow-hotplug eth0
no-auto-down eth0
# Bridge as DHCP
auto br0
iface br0 inet dhcp
    bridge_ports eth0
~~~

Then restart the *networking* service:

~~~bash
sudo systemctl restart networking.service
~~~

**<u>i.</u>** As **Static**:

~~~yaml
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# Wired adapter #1
allow-hotplug eth0
no-auto-down eth0
# Bridge setup to static IP
auto br0
iface br0 inet static
	address 10.1.1.10
	broadcast 10.1.1.255
	netmask 255.255.255.0
	gateway 10.1.1.1
	bridge_ports eth0
	bridge_stp off       # disable Spanning Tree Protocol
    bridge_waitport 0    # no delay before a port becomes available
    bridge_fd 0          # no forwarding delay
~~~

Then restart the *networking* service:

~~~bash
sudo systemctl restart networking.service
~~~



<span id="5.2"></span>

<mark>**With VLAN**</mark> (Advanced Example)

Make sure the *vlan* package is installed on the system:

```bash
sudo apt install vlan -y
```

If the host is a hypervisor consider adding below `sysctl` configurations:

```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.arp_filter=0" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=2" | sudo tee -a /etc/sysctl.conf
```

Load configurations:

```bash
$ sudo sysctl -p
```

> net.ipv4.ip_forward = 1
> net.ipv4.conf.all.arp_filter = 0
> net.ipv4.conf.all.rp_filter = 2

Then modify interfaces configurations:

~~~bash
sudo vim  /etc/network/interfaces
~~~

The interface content is as follow:

~~~yaml
source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# Wired adapter #1
allow-hotplug eth0
iface eth0 inet manual
    pre-up ifconfig $IFACE up
    pre-down ifconfig $IFACE down

# VLAN 3
auto eth0.3
iface eth0.3 inet manual

# Bridge br0
auto br0
iface br0 inet static
    bridge_ports eth0.3
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    address 10.3.3.3
    netmask 255.255.255.0
    gateway 10.3.3.1
    dns-nameservers 1.1.1.1 8.8.4.4
~~~

Then restart the *networking* service:

~~~bash
sudo systemctl restart networking.service
~~~



---


<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Conclusion:</b> </font></td></tr></table>

> Each Linux distribution may have different methods for setting a static IP address, but the process is generally similar.


---


<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Reference:</b> </font></td></tr></table>

- [How to Set Static IP Address and Configure Network in Linux (tecmint.com)](https://www.tecmint.com/set-add-static-ip-address-in-linux/)

- [如何在Ubuntu Server 18.04 LTS中配置靜態IP地址 - soso101 - 博客園 (cnblogs.com)](https://www.cnblogs.com/nuoforever/p/14177682.html)

- [Create Linux Bridge on VLAN Interface in Debian 11/10](https://techviewleo.com/create-linux-bridge-on-vlan-interface-in-debian-ubuntu/?expand_article=1)



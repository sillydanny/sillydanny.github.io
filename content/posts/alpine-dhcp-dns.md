---
title: "Alpine Linux as a DHCP and DNS Server"
date: 2023-05-26T11:14:32+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- dhcp
- dns
- dnsmasq
cover:
    image: "img/alpine-dhcp-dns/alpine-dhcp-dns.jpg"
---



> `dnsmasq` is a lightweight, easy-to-configure DHCP and DNS server. I'll demonstrate how to set up `dnsmasq` as both a DHCP and DNS server on a Linux system.

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Procedure</b></font></td></tr></table>

## Procedure

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Network Card Configuration :</b> </font></td></tr></table>

### Network Card Configuration

```bash
ip address
```

![2023-03-29_083957.png](/img/alpine-dhcp-dns/2023-03-29_083957.png)

The physical interface `eth1` is used to set up DHCP and DNS services.

~~~vim
cat >> /etc/network/interfaces << EOF
auto eth1
iface eth1 inet static
        address 192.168.0.1
        network 192.168.0.0
        netmark 255.255.255.0
        broadcast 192.168.0.255
EOF
~~~

Restart the networking to apply the settings.

~~~bash
rc-service networking restart
~~~





<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>DNSMASQ Configuration :</b> </font></td></tr></table>

### DNSMASQ Configuration

Install `dnsmasq`:


```bash
sudo apk add dnsmasq
```

![2023-03-29_084022.png](/img/alpine-dhcp-dns/2023-03-29_084022.png)

Configure `dnsmasq`:

The main configuration file for `dnsmasq` is `/etc/dnsmasq.conf`. Open this file with a text editor:

```
sudo vi /etc/dnsmasq.conf
```

Add or modify the following lines to configure `dnsmasq` as a DHCP and DNS server. Replace the placeholders with appropriate values for your network.

```
# DHCP configuration
dhcp-range=<start-IP>,<end-IP>,<netmask>,<lease-time>
dhcp-option=option:router,<router-IP>
dhcp-option=option:dns-server,<DNS-IP>

# DNS configuration
domain=<your-domain>
local=/<your-domain>/
```



Also, can save the file in a folder (`/etc/dnsmasq.d`) which end in `.conf` .

For example:

~~~vim
cat >> /etc/dnsmasq.d/eth1.conf << EOF

# DHCP configuration

dhcp-range=192.168.0.100,192.168.0.200,255.255.255.0,12h
dhcp-option=option:router,192.168.0.1
dhcp-option=option:dns-server,192.168.0.1

# DNS configuration

domain=local.lan
local=/local.lan/
EOF
~~~



Configure local DNS entries (optional):

If you want to add custom DNS entries for your local network, you can create a new file called `/etc/hosts.dnsmasq` and add the entries in the following format:

```
<IP-address> <hostname>.<domain> <alias>
```

For example:

```
192.168.0.10 server.local.lan server
192.168.0.20 nas.local.lan nas
```

Then, add the following line to `/etc/dnsmasq.conf` to use `/etc/hosts.dnsmasq` for local DNS resolution:

```
addn-hosts=/etc/hosts.dnsmasq
```

Start and enable `dnsmasq`:

```
rc-service dnsmasq start
```

>  * /var/lib/misc/dnsmasq.leases: creating file
>  * /var/lib/misc/dnsmasq.leases: correcting owner
>  * Starting dnsmasq ...

```
rc-update add dnsmasq
```

>  * service dnsmasq added to runlevel default



---





<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Perform client PC testing</b> </font></td></tr></table>

### Perform client PC testing

Clients should receive IP addresses and DNS settings automatically when they connect, and any custom local DNS entries you configured should resolve correctly.


```bash
sudo rc-service networking restart
```

![2023-03-29_091751.png](/img/alpine-dhcp-dns/2023-03-29_091751.png)

---

Now, `dnsmasq` should be running as a DHCP and DNS server on network. 

---



<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Related</b></font></td></tr></table>

### Related

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)
- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)
- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)
- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)
- [iPXE 網絡引導安裝](https://kingtam.win/archives/ipxe.html#dnsmasq)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)

  [1]: https://kingtam.win/usr/uploads/2023/05/2487277634.png
  [2]: https://kingtam.win/usr/uploads/2023/03/2445871359.png
  [3]: https://kingtam.win/usr/uploads/2023/03/3493598533.png
  [4]: https://kingtam.win/usr/uploads/2023/03/121245582.png

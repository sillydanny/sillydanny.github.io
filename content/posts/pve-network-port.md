---
title: "PVE (Proxmox VE) Multi-port Identification"
date: 2023-05-30T13:04:14+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Linux
- PVE
tags:
- ethool 
ShowLastMod: true
cover:
    image: "img/pve-network-port/pve-network-port.jpeg"
---


# PVE (Proxmox VE) Multi-port Identification


![](/img/pve-network-port/4ad690695043721138823ed948b57dd1930070be.JPG)

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>About:</b> </font></td></tr></table>

> This is a post about network card (multiple ports) identification in the `PVE` system. Through the `ethtool` command, you can easily find the corresponding location of each network port.

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Operation Steps:</b> </font></td></tr></table>

> Take `Intel EXPI9402PTBLK 82571GB Network Adapter` as an example

Install the `ethtool` command

```bash
apt update && apt install ethtool -y
```

> `ethtool` can be used to view network device driver parameters and hardware configuration.

Check the device name of the network card in the `PVE` server

```bash
ip -c a
```

![](/img/pve-network-port/03f357cea524642d9baefe0fb96bb298ab40d9e9.png)

> Where `enp1s0f0` and `enp1s0f1` are the two network ports of the network card, corresponding to `MAC` addresses `00:24:81:7e:ce:cb` and `00:24:81:7e:ce:ca` respectively.

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Method A</b> </font></td></tr></table>

> Use `ethtool` to identify the device name and corresponding network port location in the `PVE` system.

Enter the following command to find the physical network port (network port with <mark>indicator</mark>) of the first device name `enp1s0f0`

```bash
ethtool --identify enp1s0f0
```

![](/img/pve-network-port/0bd387889a2c56308909940522e257aae2803857.JPG)

Enter the following command to find the physical network port (network port with <mark>indicator</mark>) of the second device name `enp1s0f1`

```bash
ethtool --identify enp1s0f1
```

![](/img/pve-network-port/e4bf7ea8f83f99c9cb99f3232de5aa48c7cc73ef.JPG)

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Method B</b> </font></td></tr></table>

> If the network card does not support the `ethtool --identify` command (<mark>indicator</mark>) for identification, the following method can be used.

Enable the two network ports `enp1s0f0` and `enp1s0f1` separately

```bash
ifup enp1s0f0
ifup enp1s0f1
```

Insert the network cable (`Cat5e`) into one of the network ports of the network card (`Intel EXPI9402PTBLK 82571GB`) and the other end of the network cable into another powered network port, such as a switch, router, computer, etc.

At this time, enter the command to view the network port status

```bash
ethtool enp1s0f0
```

![](/img/pve-network-port/0ae1c36a7c4b94d47095fa9cbcb4067f9ed46d9a.png)

As shown in the figure, **<mark>Link detected: yes</mark>** indicates that the found network port is `enp1s0f0`.

On the contrary, it shows **<mark>Link detected: no</mark>**, indicating the network port `enp1s0f1` without a cable.

<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Device Location</b> </font></td></tr></table>

> When directly passing a specified network port, `ethtool` can easily find the location of the network port in the `PVE` system.

View all physical network cards and locations of the server

```bash
lspci | grep -in 'eth'
```

View the location of the first network port `enp1s0f0`

```bash
ethtool -i enp1s0f0
```

View the location of the second network port `enp1s0f1`

```bash
ethtool -i enp1s0f1
```

![](/img/pve-network-port/77139e895064f22fe3c9b8a37bc6fec0ef9cb8f2.png)

> As shown in the figure, the location of the first network port `enp1s0f0` is `01:00.0`, and the location of the second network port `enp1s0f1` is `01:00.1`.

Finally, pass through the specified network card or network port in the virtual machine.

![](/img/pve-network-port/c62b37f95b51925a487c92606e0215e9ecc9bc35.png)

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Conclusion:</b> </font></td></tr></table>

> Using `ethtool` to identify multiple network ports of a network card is really convenient.

> Finally, a corresponding table can be made to facilitate future lookups.

| Physical Network Card | MAC Address | PVE Device Name | Device Location (for passthrough) | VM Name |
| ----- | ----------------- | -------- | ---------- | ----- |
| 1st Port | 00:24:81:7E:CE:CB | enp1s0f0 | 01:00.0    | LAN   |
| 2nd Port | 00:24:81:7E:CE:CA | enp1s0f1 | 01:00.1    | WAN   |

<table><tr align="left"><td bgcolor=#33B679><font size=5 color=white><b>Reference:</b> </font></td></tr></table>

[圖哥-通用PVE AIO安装教程 ](https://gitee.com/spoto/PVE_Generic_AIO/tree/master/0%E3%80%81%E5%88%9B%E5%BB%BA%E8%BD%AF%E8%B7%AF%E7%94%B1%E8%99%9A%E6%8B%9F%E6%9C%BA)

---

<table><tr align="left"><td bgcolor=#33B679><font size="5" color="white"><b>Related:</b></font></td></tr></table>

- [Proxmox VE 01 - 系統安裝篇](https://kingtam.win/archives/pve01.html)
- [遷移 VMware *ESXi* 的 ova 文件到 Proxmox 7.0](https://kingtam.win/archives/esxi-to-pve.html)
- [PVE 的 LXC 容器系統安裝 CUPS 軟件，實現多平台共享的印表機](https://kingtam.win/archives/cups.html)
- [Proxmox VE 7 安裝Home Assistant虛擬機系統](https://kingtam.win/archives/hass.html)
- [Managing LXC in Proxmox Virtual Environment (PVE)](https://kingtam.win/archives/lxc.html)
- [Configuring VLANs on a Host for Proxmox VE](https://kingtam.win/archives/vlan-on-the-Host.html)

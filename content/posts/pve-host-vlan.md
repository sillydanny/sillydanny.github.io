---
title: "Configuring VLANs on a Host for PVE (Proxmox VE)"
date: 2023-05-30T13:39:16+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Linux
- PVE
tags:
- vlan 
ShowLastMod: true
cover:
    image: "img/pve-host-vlan/pve-host-vlan.png"
---


# Configuring VLANs on a Host for Proxmox VE

>  In today's increasingly complex networking environments, Virtual Local Area Networks (VLANs) have become a crucial tool for managing network traffic and ensuring optimal performance.
>
> This blog post provides a step-by-step guide on configuring VLANs on a host for Proxmox Virtual Environment (VE), a popular open-source virtualization platform.

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Why use VLANs with Proxmox VE?</b></font></td></tr></table>

VLANs allow you to segregate network traffic into isolated broadcast domains, improving security and reducing network congestion. By configuring VLANs on a Proxmox VE host, you can:

1. Improve network performance by reducing broadcast traffic.
2. Enhance security by isolating sensitive virtual machines (VMs) and containers.
3. Simplify network management and troubleshooting.

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Prerequisites</b></font></td></tr></table>

> Before proceeding, ensure you have the following:

1. A Proxmox VE host installed and configured.
2. A managed network switch that supports VLAN tagging (IEEE 802.1Q).

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Procedures:</b></font></td></tr></table>

This guide provides procedures for configuring VLANs on a host for  Proxmox Virtual Environment (VE).

This guide provides instructions for configuring VLANs, with separate  sections for both the command line interface (CLI) and the graphical  user interface (GUI).

---



<table><tr align="left"><td bgcolor=#25add7><font color=white><b>The Command Line Interface (CLI) Configuration</b> </font></td></tr></table>



<table><tr align="left"><td bgcolor=#8000D7><font size=2 color=white><b>Step 1: A Proxmox VE host configurration</b> </font></td></tr></table>



Edit configuration file for the VLAN interface in `/etc/network/interfaces`.

```sh
vi /etc/network/interfaces
```

The `eno1 ` is a  physical network interface and `vmbr0`  is a Linux Bridge.

the following configuration, adjusting the `address` and `gateway` parameters as needed

> Use `VLAN 2` for the Proxmox VE management IP with VLAN aware Linux bridge

```bash
auto lo
iface lo inet loopback

iface eno1 inet manual

auto vmbr0.2
iface vmbr0.2 inet static
        address 10.2.2.254/24
        gateway 10.2.2.1

auto vmbr0
iface vmbr0 inet static
        bridge-ports eno1
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        bridge-vids 1-4094
```

Save the file and exit the editor use `:wq`

Apply the new configuration by restarting the networking service:

```sh
systemctl restart networking
```





<table><tr align="left"><td bgcolor=#8000D7><font size=2 color=white><b>Step2: Configure a managed Network Switch </b> </font></td></tr></table>

> In this scenario, use *Cisco SG300-10P* 10-Port Gigabit Managed Switch.

The command "`enable`" is used to enter privileged EXEC mode on a Cisco SG300-10 switch, which allows access to configuration and management commands.

~~~bash
enable
~~~



The subsequent command "`configuration terminal`" is used to enter global configuration mode, which allows the user to configure various aspects of the switch's behavior.

~~~bash
configuration terminal
~~~



The command "`interface gigabitethernet2`" is used to select the Gigabit Ethernet interface 2 on the switch for configuration.

The command "`description VMS01`" is used to assign a description to the selected interface, in this case labeling it as "`VMS01`", which standard for Virtual Machine Server.

The command "`switchport trunk allowed vlan add 2-4,11`" is used to configure the selected interface as a <mark>trunk</mark> port and allow traffic from VLANs 2, 3, 4, and 11 to pass through the port. The "add" keyword specifies that these VLANs should be added to the existing list of allowed VLANs, if any.

~~~
interface gigabitethernet2
description VMS01
switchport trunk allowed vlan add 2-4,11
~~~

<table><tr align="left"><td bgcolor=#8000D7><font size=2 color=white><b>Step 3: Assign VLAN to VMs or Containers </b> </font></td></tr></table>

Finally, assign the newly created bridge to your VMs or containers:

> This sample use container.

1. Select the desired container in the Proxmox VE web interface.
2. Go to the **Network** tab.
3. Click **Edit**.
4. Select the bridge (e.g., `vmbr0`) from the **Bridge** dropdown menu.
5. Assign a vlan number in **VLAN Tag**
6. Click **OK** to apply the changes.

Repeat these steps for each container you want to assign to the VLAN.

![](/img/pve-host-vlan/2023-03-24_141304.png)

`no VLAN` as PVID vlan1



![](/img/pve-host-vlan/2023-03-24_141340.png)

![](/img/pve-host-vlan/2023-03-24_141414.png)



---

<table><tr align="left"><td bgcolor=#25add7><font color=white><b>Graphical  User Interface (GUI) Configuration</b> </font></td></tr></table>

<table><tr align="left"><td bgcolor=#8000D7><font size=2 color=white><b>Step 1: Configure Proxmox VE Network </b> </font></td></tr></table>

Now, create a new Linux Bridge or Open vSwitch in the Proxmox VE web interface:

1. Log in to the Proxmox VE web interface.
2. Go to **Datacenter > vms02 (your-node) > System > Network**.
3. Click "**Create > Linux Bridge**" or " Edit the Existing **vmbr0** of Linux Bridge" (depending on your preference).
4. Add the VLAN interface to the **Bridge ports** field.

![](/img/pve-host-vlan/2023-03-24_133246.png)

![](/img/pve-host-vlan/2023-03-24_132715.png)

![](/img/pve-host-vlan/2023-03-24_133233.png)

<table><tr align="left"><td bgcolor=#8000D7><font size=2 color=white><b>Step2: Configure a managed Network Switch </b> </font></td></tr></table>

![](/img/pve-host-vlan/2023-03-24_095806.png)

PVID (Default Vlan ID) as `1`

![](/img/pve-host-vlan/2023-03-24_095945.png)

Configure the `GE2` interface as a <mark>Trunk</mark> port and allow traffic from VLANs `2`, `3`, `4`, and `11` to pass through the port, with VLAN1 as the Default Vlan without Vlan Tag.

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Conclusion</b></font></td></tr></table>

> By following this guide, you've successfully configured VLANs on a Proxmox VE host and assigned them to your VMs and containers. This will help you optimize network performance, enhance security, and simplify network management in your virtual environment.



---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Reference:</b></font></td></tr></table>

- https://pve.proxmox.com/wiki/Network_Configuration



---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Related:</b></font></td></tr></table>

- [Proxmox VE 01 - 系統安裝篇](https://kingtam.win/archives/pve01.html)
- [遷移 VMware *ESXi* 的 ova 文件到 Proxmox 7.0](https://kingtam.win/archives/esxi-to-pve.html)
- [PVE 的 LXC 容器系統安裝 CUPS 軟件，實現多平台共享的印表機](https://kingtam.win/archives/cups.html)
- [PVE (Proxmox VE) 多網口的識別](https://kingtam.win/archives/ethtool.html)
- [Proxmox VE 7 安裝Home Assistant虛擬機系統](https://kingtam.win/archives/hass.html)
- [Managing LXC in Proxmox Virtual Environment (PVE)](https://kingtam.win/archives/lxc.html)
- [在 Ubuntu 中設置 VLAN](https://kingtam.win/archives/linux_static_ip.html#vlan)



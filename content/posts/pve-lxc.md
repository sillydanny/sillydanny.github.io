---
title: "Managing LXC in Proxmox Virtual Environment (PVE)"
date: 2023-05-29T13:08:23+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- PVE
- Linux
tags:
- LXC
- CT
ShowLastMod: true
cover:
    image: "img/pve-lxc/pve-lxc.png"
---



We will explore the syntax of managing [LXC ](https://linuxcontainers.org/lxc/introduction/) using [PVE](https://pve.proxmox.com/wiki/Main_Page). Use commands that are commonly used by system administrators and cover the basics of creating, removing, and managing LXC in PVE.

---

# What's LXC?

LXC is a user space interface for the Linux kernel containment  features. Through a powerful API and simple tools, it lets Linux users  easily create and manage system or application containers.



---

### Template Image

Creating an LXC in PVE is to download a template image. A template image is a preconfigured image of an operating system that can be used to create new LXC quickly.

The first step update container template database:

```
pveam update
```

List available images:

```
pveam available
```

Also filter the output:

```
pveam available --section system
```

The following command downloads a template image of an Ubuntu 22.04 operating system and saves it in the storage pool named "volume01":

```
pveam download volume01 vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst
```

Listing Template Images
To see a list of all the template images stored in the storage pool named "volume01," use the following command:

```
pveam list volume01
```

> NAME                                                         SIZE
> volume01:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst  123.81MB

---

### Creating an LXC

Now that we have a template image, we can create a new LXC.

```
pct create 403 volume01:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst \
  --storage volume01 --rootfs volume=volume01:16 \
  --ostype ubuntu --arch amd64 --password P@ssw0rd --unprivileged 1 \
  --cores 2 --memory 1024 --swap 0 \
  --hostname lxc-ubuntu \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp,firewall=1,type=veth \
  --start true
```

Configuring the LXC

| Parameter                                                    | Description                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `pct create`                                                 | creates a new LXC with ID 403 and the image from the storage "volume01. |
| `--storage volume01`                                         | specifies the storage pool to be used for storing the LXC's disks. |
| `--ostype ubuntu --arch amd64`                               | specify the operating system and architecture of the LXC.    |
| `--password P@ssw0rd --unprivileged 1`                       | set the root password for the LXC and enable unprivileged mode. |
| `--cores 2 --memory 1024 --swap 0`                           | specify the number of CPU cores, amount of memory and swap space allocated to the LXC. |
| `--hostname lxc-ubuntu`                                      | This option sets the hostname of the LXC to "lxc-ubuntu".    |
| `--net0 name=eth0,bridge=vmbr0,ip=dhcp,firewall=1,type=veth` | the interface name set to eth0 and bridge to vmbr0 from the host, enable firewall and the network type value is: **veth**. |
| `--start true`                                               | This option starts the LXC after it has been created.        |

about **veth**

> This type of network interface allows the LXC (container) or virtual machine  to communicate with other devices on the network as if it were a  physical device on the network. The veth interface also allows for  network isolation between different LXC or virtual machines  running on the same host system.

---

### Launch a shell for the LXC

 Enter the container:

```
pct enter 403
```

 Update the system:

```
apt update && apt upgrade
```

 Install some packages:

```
apt install -y curl git tmuxvim
```

Set Vim as default editor:

```
update-alternatives --set editor /usr/bin/vim.basic
```

Create user:

```
useradd -m user -s /bin/bash
```

Switch to user:

```
su - user
```



---

### Cleaning up

Stop the LXC

~~~
pct stop 401
~~~



Destroying an LXC

To remove an LXC from the system, use the following command:

```
pct destroy 401 --purge
```

This command destroys the LXC with ID 401 and removes its configuration files from the system.



Removing a Template Image
If you want to remove a template image from the storage pool, use the following command:

```
pveam remove volume01:vztmpl/vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst
```

---

### Conclusion:

We covered the basics of managing LXC in Proxmox Virtual Environment (PVE).

Looked at how to download a template image, create an LXC, and configure it with various options. We also saw how to remove an LXC from the system.

PVE offers many more commands and options for managing LXCs, and we encourage you to explore them further to get the most out of this powerful virtualization platform.

---



### Reference:

- https://pve.proxmox.com/pve-docs/pct.1.html
- https://www.chucknemeth.com/proxmox/lxc/lxc-template

---

### Related:

- [Proxmox VE 01 - 系統安裝篇](https://kingtam.win/archives/pve01.html)
- [遷移 VMware *ESXi* 的 ova 文件到 Proxmox 7.0](https://kingtam.win/archives/esxi-to-pve.html)
- [PVE 的 LXC 容器系統安裝 CUPS 軟件，實現多平台共享的印表機](https://kingtam.win/archives/cups.html)
- [PVE (Proxmox VE) 多網口的識別](https://kingtam.win/archives/ethtool.html)
- [Proxmox VE 7 安裝Home Assistant虛擬機系統](https://kingtam.win/archives/hass.html)
- [Configuring VLANs on a Host for Proxmox VE](https://kingtam.win/archives/vlan-on-the-Host.html)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)




---
title: "Alpine Installation"
date: 2023-05-24T09:03:51+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- Installation
#tags: ["installation"]
cover:
    image: "img/alpine-installation/alpine-install.jpg"
---



### Why Alpine Linux

> Alpine Linux is a lightweight, security-focused, rolling release distribution with a fast and efficient package manager. It is highly customizable and compatible with a wide range of hardware architectures, making it suitable for use in a variety of environments.

---


### Preparation

1. Download the Alpine Linux ISO image file from the official website: https://alpinelinux.org/downloads/
2. Write the ISO image file to a USB drive using a tool such as Rufus or Etcher.
3. Insert the USB drive into your computer and boot from it. This can usually be done by pressing a key (such as F12 or Del) during the startup process to enter the boot menu, then selecting the USB drive as the boot device.

![2023-03-26_105212.png](/img/alpine-installation/2023-03-26_105212.png)

---


### Procedure of Install


![2023-03-26_105713.png](/img/alpine-installation/2023-03-26_105713.png)

Once Alpine Linux has booted, you will see a command-line interface. Type the login name "`root`" and press Enter.

Setup the system with command “`setup-alpine`”.



![2023-03-26_105732.png](/img/alpine-installation/2023-03-26_105732.png)

Follow the prompts to select the keyboard layout (or press enter to select `none`), and type system hostname (e.g. `alpine`)

Constantly choosing default settings, such as interface `eth0`, using `DHCP` to ask for an IP address.


![2023-03-26_105757.png](/img/alpine-installation/2023-03-26_105757.png)

Enter it twice to change the `root password`, and select the appropriate time zone for your location or enter it manually (e.g. `Asia/Hong_Kong`).


![2023-03-26_105829.png](/img/alpine-installation/2023-03-26_105829.png)

Choose the fastest repository (e.g. `1`)


![2023-03-26_105902.png](/img/alpine-installation/2023-03-26_105902.png)

Type a username or press enter to choose `no`.


![2023-03-26_105937.png](/img/alpine-installation/2023-03-26_105937.png)

Select `openssh` as ssh server.


![2023-03-26_110016.png](/img/alpine-installation/2023-03-26_110016.png)

Next, prompt to select Available disks. Enter a disk name (such as `sda`) to use for installing the system.

Enter the name `sys` as the base system  then type `y` to confirm  erasing the disk and starting the formatting and base system  installation process.

Finally, you will be prompted to reboot the system. Remove the USB drive and type `reboot` to restart the system.

---

### Congratulations, Alpine Linux is successfully installed!



---


### Related

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)
- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)
- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)
- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)

  [1]: https://kingtam.win/usr/uploads/2023/05/3047617526.png
  [2]: https://kingtam.win/usr/uploads/2023/03/3316687039.png
  [3]: https://kingtam.win/usr/uploads/2023/03/4270205594.png
  [4]: https://kingtam.win/usr/uploads/2023/03/3391181966.png
  [5]: https://kingtam.win/usr/uploads/2023/03/651055989.png
  [6]: https://kingtam.win/usr/uploads/2023/03/1687135105.png
  [7]: https://kingtam.win/usr/uploads/2023/03/3199418415.png
  [8]: https://kingtam.win/usr/uploads/2023/03/361477065.png
  [9]: https://kingtam.win/usr/uploads/2023/03/1146163973.png

---
title: "Deploy OpenWrt with Docker Compose"
date: 2023-06-30T14:11:49+08:00
draft: false
author: "King Tam"
summary: "Use Docker to deploy OpenWrt with Docker Compose, it's easy to create and manage containers, making it an ideal solution for deploying OpenWrt on embedded devices." 
showToc: true
categories:
- Network
tags:
- docker
- docker-compose
- OpenWRT
ShowLastMod: true
cover:
    image: "img/docker-openwrt/docker-openwrt.jpg"
---

> Use Docker to deploy OpenWrt with Docker Compose, it's easy to create and manage containers, making it an ideal solution for deploying OpenWrt on embedded devices.



---


### Features

- OpenWrt official OpenWrt-22.03 branch version, Kernel 5.15, synchronized with the latest official source code.
- The original firmware is extremely pure. It only includes basic Internet access functions by default, and plug-ins can be selected online.
- The self-built plug-in repository includes almost all open source plug-ins.
- Customize through supes.top without requiring professional knowledge, and generate it in one minute.
- One-click OTA firmware update in the background.
- One-click bypass route (SideRouter) and one-click switch IPv6.
- Supports online installation of all Kmod kernel modules.
- Replaces Uhttpd with Nginx, supporting reverse proxy, WebDAV, and more.
- Out-of-the-box (OOTB) feature.

---



### Networking Information

Before we begin, let's find out the networking information on the Linux system we will be using to deploy OpenWrt.

```bash
ip route
```

> default via 10.1.1.1 dev eth0  metric 202
> 10.1.1.0/24 dev eth0 scope link  src 10.1.1.97
> 172.17.0.0/16 dev docker0 scope link  src 172.17.0.1

This command will display the routing table of the system, which includes the default gateway, subnet, and interface information.

| Name            | Parameter   |
| :-------------- | :---------- |
| Interface       | eth0        |
| Default Gateway | 10.1.1.1    |
| Subnet          | 10.1.1.0/24 |

Enable the NIC (Network Interface Controller) promiscuous mode.

> This is necessary for the OpenWrt container to access the internet.

```bash
ip link set eth0 promisc on
```

If unsure which interface to use, we can run the following command to automatically detect and enable promiscuous mode:

```bash
ip link set $(ip route | awk '/default/ {print $5}') promisc on
```

To check the promiscuous mode status, run the following command:

```bash
ip -d link | grep "promiscuity 1"
```

If the output shows "`promiscuity 1`", then promiscuous mode is enabled.

---





### Download the latest Image

Download the latest OpenWrt image via [Download or customize the OpenWrt firmware for your device ](https://supes.top/?version=22.03&target=x86%2F64&id=generic)

In this scenario, use Docker or LXC type for the architecture of the x86_x64 system.

![2023-05-17_081822](/img/docker-openwrt/2023-05-17_081822.png)

```bash
wget https://supes.top/releases/targets/x86/64/openwrt-04.18.2023-x86-64-generic-rootfs.tar.gz
```

> --2023-05-15 16:50:30--  https://supes.top/releases/targets/x86/64/openwrt-04.18.2023-x86-64-generic-rootfs.tar.gz
> Resolving supes.top (supes.top)... 104.21.4.157
> Connecting to supes.top (supes.top)|104.21.4.157|:443... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 98339727 (94M) [application/octet-stream]
> Saving to: ‘openwrt-04.18.2023-x86-64-generic-rootfs.tar.gz’
>
> openwrt-04.18.2023-x86-64-gen 100%[=================================================>]  93.78M  61.5MB/s    in 1.5s
>
> 2023-05-15 16:50:32 (61.5 MB/s) - ‘openwrt-04.18.2023-x86-64-generic-rootfs.tar.gz’ saved [98339727/98339727]

Once the image is downloaded, import it into Docker

```bash
docker import openwrt-04.18.2023-x86-64-generic-rootfs.tar.gz supes_openwrt
```

> sha256:a31010a2bdc1b008522980d94da145883b663fb2fc86e91eacb85f22b0850cd0

Verify that the image has been imported successfully

```bash
docker images
```

> REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
> supes_openwrt   latest    36f25cd1cee7   6 seconds ago   275MB

---





### Start to Deploy

Using a Docker Compose file to define our container configuration.

Create a new file named "`docker-compose.yml`" with the following YAML code:

```yaml
cat >> docker-compose.yml << EOF
version: '3.8'

services:
  openwrt:
    image: supes_openwrt
    container_name: openwrt
    command: /sbin/init
    privileged: true
    restart: always
    networks:
      openwrt-macvlan:
        ipv4_address: 10.1.1.11

networks:
  openwrt-macvlan:
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        - subnet: 10.1.1.0/24
          gateway: 10.1.1.1
EOF
```

This Docker Compose file defines a single service named "`openwrt`" that uses the "`supes_openwrt`" image we imported earlier.

Specifies that the container should be run in `privileged` mode and `restarted automatically` if it stops. Defines a network named "`openwrt-macvlan`" that uses the "`macvlan`" driver to create a virtual network interface for the container.

The network is assigned an IP address of `10.1.1.11` with a subnet of `10.1.1.0/24` and a gateway of `10.1.1.1`.

To start the deployment

```bash
docker compose up -d
```

> [+] Running 2/2
> ✔ Network root_openwrt  Created
> ✔ Container openwrt     Started

To check the status of the container, run the following command:

```bash
docker compose ps
```

If everything is working correctly, you should see the "openwrt" service running with the status.

> NAME                IMAGE               COMMAND             SERVICE             CREATED              STATUS              PORTS
> openwrt             supes_openwrt       "/sbin/init"        openwrt             About a minute ago   Up About a minute

---



### Modify OpenWrt login IP

Access the OpenWrt container

```bash
docker exec -it openwrt sh
```

> BusyBox v1.35.0 (2023-04-30 14:20:01 UTC) built-in shell (ash)

The default login IP is `10.0.0.1`. Use the IP `10.3.3.11` instead, and adjust it according to your personal situation.

~~~bash
sed -i 's/10.0.0.1/10.1.1.11/' /etc/config/network && /etc/init.d/network restart
~~~

---





### Set OpenWrt  to bypass mode (SideRouter)

> Use the new IP address `10.1.1.11` login to OpenWRT via Browser and set up SideRouter mode.Default login password : `root`

![2023-05-16_114018](/img/docker-openwrt/2023-05-16_114018.png)

![2023-05-16_114336](/img/docker-openwrt/2023-05-16_114336.png)



###

### Conclusion

> kiddin9's OpenWrt firmware offers customizable routers with the latest version and kernel, self-built plug-in warehouse, and easy customization through https://supes.top.

> It supports one-click updates, bypass route, IPv6 switch, and online installation of all Kmod kernel modules. It replaces Uhttpd with Nginx, supporting reverse proxy, WebDAV, and more. All features are OOTB, making it easy for non-technical users.

> Thanks to the author for this useful resource.

---

### Reference

- [Author GitHub Page](https://github.com/kiddin9/OpenWrt_x86-r2s-r4s-r5s-N1)
- [下載或定製適用於您裝置的OpenWrt韌體](https://supes.top/?version=22.03&target=x86%2F64&id=generic)
- [Docker版OpenWrt旁路由安装设置教程](https://supes.top/docker%E7%89%88openwrt%E6%97%81%E8%B7%AF%E7%94%B1%E5%AE%89%E8%A3%85%E8%AE%BE%E7%BD%AE%E6%95%99%E7%A8%8B/)

---

### Related

- [VPS uses Docker deployment to automatically renew freenom domain name](https://kingtam.win/archives/freenom-renew.html)
- [Docker Application of OneCloud](https://kingtam.win/archives/onecloud-2.html)
- [Deploy KMS with Docker](https://kingtam.win/archives/kms.html)
- [Let NPM (Nginx Proxy Manager) and FRP (Fast Reverse Proxy) share 80/443 ports with wildcard domain](https://kingtam.win/archives/frp-with-npm.html)
- [Use Docker to Deploy FRP Services](https://kingtam.win/archives/frp.html)
- [Install Docker and Docker Compose via shell script](https://kingtam.win/archives/script-install-docker.html)
- [Deploy FRP server and client services using Docker via shell script](https://kingtam.win/archives/frp-deploy.html)

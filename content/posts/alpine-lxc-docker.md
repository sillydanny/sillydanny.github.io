---
title: "Alpine Linux-based LXC with Docker support on a PVE host"
date: 2023-05-25T11:14:32+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- lxc
- docker
cover:
    image: "img/alpine-lxc-docker/alpine-lxc-docker.jpg"
---


> Setting up an Alpine Linux-based Container (LXC) with Docker support on a Proxmox Virtual Environment (PVE) host.


- Lightweight and secure: Alpine Linux is a lightweight and secure distribution of Linux that is ideal for use in containers. It has a small footprint and is designed to minimize attack surface, making it a good choice for running Docker containers.
- Flexibility: Using an LXC container allows you to run multiple instances of Docker on a single host, each with its own isolated environment and resources.
- Easy management: Proxmox VE provides a user-friendly web interface for managing LXC containers, making it easy to start, stop, and configure containers.
- Resource efficiency: Running Docker inside an LXC container allows you to maximize resource usage by sharing resources across multiple containers. This can lead to better performance and reduced resource usage compared to running Docker directly on the host.
- Modularity: Using Docker allows you to easily manage and deploy applications in a modular way, with each container running a specific service or application. This can simplify the management and maintenance of complex systems.

---



Create a new LXC container with the specified configuration:

   ```yaml
pct create 302 volume01:vztmpl/alpine-3.17-default_20221129_amd64.tar.xz \
  --storage volume01 --rootfs volume=volume01:8 \
  --ostype alpine --arch amd64 --password P@ssw0rd --unprivileged 0 \
  --cores 2 --memory 1024 --swap 0 \
  --hostname lxc-alpine \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp,firewall=1,type=veth \
  --start false
   ```

| Configuration Option  | Value                                               |
| --------------------- | --------------------------------------------------- |
| Container ID          | 302                                                 |
| Template              | Alpine Linux                                        |
| Storage               | volume01                                            |
| Root Filesystem Size  | volume=volume01:8                                   |
| Operating System Type | Alpine                                              |
| Architecture          | amd64                                               |
| Password              | P@ssw0rd                                            |
| Container Privileges  | 0 means the container with privileged mode enabled  |
| CPU Cores             | 2                                                   |
| Memory                | 1024                                                |
| Swap                  | 0                                                   |
| Hostname              | lxc-alpine                                          |
| Network Settings      | name=eth0,bridge=vmbr0,ip=dhcp,firewall=1,type=veth |

Configure the LXC container to use an unconfined AppArmor profile and drop no capabilities:

   ```yaml
cat >> /etc/pve/lxc/302.conf << EOF
lxc.apparmor.profile: unconfined
lxc.cap.drop:
EOF
   ```

| Action                             | Command                                       |
| ---------------------------------- | --------------------------------------------- |
| Container config file Location     | `/etc/pve/lxc/302.conf`                       |
| `lxc.apparmor.profile: unconfined` | Disabling AppArmor confinement                |
| `lxc.cap.drop:`                    | Retaining all capabilities for the container. |

Start the LXC container:

~~~bash
pct start 302
~~~



---


Update and upgrade the container's package repositories and installed packages:

   ```bash
apk update && apk upgrade
   ```

   This command updates the Alpine package repositories and upgrades the installed packages to their latest versions.

Install Docker and Docker Compose:

   ```bash
apk add docker docker-compose
   ```

   This command installs Docker and Docker Compose, which are used to manage and deploy containerized applications.

Start the Docker service and enable it to start automatically on boot:

   ```bash
rc-service docker start
rc-update add docker
   ```

   These commands start the Docker service and configure it to start automatically when the container boots.

Create the Docker configuration directory:

   ```bash
mkdir -p /etc/docker
   ```

Configure the Docker daemon with custom log and storage settings:

   ```json
cat > /etc/docker/daemon.json << EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "20m",
        "max-file": "3"
    },
    "storage-driver": "vfs"
}
EOF
   ```

| Parameter              | Value                      |
| ---------------------- | -------------------------- |
| File Location          | /etc/docker/daemon.json    |
| Logging Driver         | json-file                  |
| Logging Driver Options | max-size: 20m, max-file: 3 |
| Storage Driver         | vfs                        |


Restart the Docker service to apply the configuration changes:

   ```bash
rc-service docker restart
   ```

---




> Setting up an Alpine Linux-based Container (LXC) with Docker support on a Proxmox Virtual Environment (PVE) host provides a secure, flexible, and efficient way to run Docker containers.

---


- [在 Alpine Linux 3 底下安裝 docker + docker-compose](https://www.ichiayi.com/tech/alpine_docker)



---




- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)
- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)
- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)
- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)
- [Managing LXC in Proxmox Virtual Environment (PVE)](https://kingtam.win/archives/lxc.html)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)


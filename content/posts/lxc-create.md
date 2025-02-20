---
title: "PCT commands"
date: 2025-02-12T12:57:07+08:00
draft: false
author: "King Tam"
summary: "" 
showToc: true
categories:
- Linux
- PVE
- Network
tags:
- pct
- lxc
ShowLastMod: true
cover:
    image: "img/lxc-create/Cover.jpeg"
---

### Using `pct` in Proxmox VE

Proxmox VE (PVE) is a powerful open-source virtualization platform that supports both LXC containers and KVM virtual machines. The `pct` command line tool is specifically designed to manage LXC containers. Below is a detailed step-by-step guide to help master the `pct` command.

------

### **1. Prerequisites**

Before using `pct`, ensure:

![2025-02-14_templates ](/img/lxc-create/2025-02-14_templates.png)

- Necessary OS templates (e.g., Ubuntu, Debian, CentOS) are downloaded from the Proxmox template repository.

------

### **2. Basic Commands**

#### **2.1 Create a New Container**

To create a new LXC container, use the `pct create` command.

```bash
pct create <vmid> <ostemplate> [options]
```

**Example:**

```bash
pct create 100 local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz \
  --storage local-lvm \
  --rootfs 8G \
  --hostname LXC-100 \
  --memory 1024 \
  --cores 1 \
  --net0 name=eth0,bridge=vmbr0,ip=dhcp
```

**Explanation:**

- `100`: The unique ID for the container.
- `local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz`: The OS template to use.
- `--storage local-lvm`: The storage where the container will be created.
- `--rootfs 8G`: Allocate 8GB of disk space for the root filesystem.
- `--hostname LXC-100`: Set the hostname for the container.
- `--memory 1024`: Allocate 1024MB of RAM.
- `--cores 1`: Assign 1 CPU core.
- `--net0`: Configure the network interface (DHCP in this case).

------

#### **2.2 Start a Container**

To start a container, use the `pct start` command.



```bash
pct start <vmid>
```

**Example:**

```bash
pct start 100
```

------

#### **2.3 Stop a Container**

To stop a running container, use the `pct stop` command.

```bash
pct stop <vmid>
```

**Example:**

```bash
pct stop 100
```

------

#### **2.4 Restart a Container**

To restart a container, use the `pct restart` command.

```bash
pct restart <vmid>
```

**Example:**

```bash
pct restart 100
```

------

#### **2.5 Access the Container's Shell**

To access the container's shell, use the `pct enter` command.

```bash
pct enter <vmid>
```

**Example:**

```bash
pct enter 100
```

------

#### **2.6 List All Containers**

To list all containers on the node, use the `pct list` command.

```
pct list
```

**Output Example:**

```bash
VMID       Status     Lock         Name
100        running                 lxc-100
101        stopped                 lxc-101
```

------

#### **2.7 Modify Container Configuration**

To modify a container's configuration, use the `pct set` command.

```bash
pct set <vmid> [options]
```

**Example (Increase Memory Limit):**

```bash
pct set 100 --memory 2048
```

**Example (Add a Mount Point):**

```bash
pct set 100 --mp0 /mnt/data,/mnt/data,ro
```

------

#### **2.8 Clone a Container**

To clone an existing container, use the `pct clone` command.

```bash
pct clone <source-vmid> <new-vmid> [options]
```

**Example:**

```bash
pct clone 100 101 --storage local-lvm
```

------

#### **2.9 Backup a Container**

To create a backup of a container, use the `vzdump ` command.

**Example:**

![2025-02-14_backup](/img/lxc-create/2025-02-14_backup.png)

Backup Container ID 302 (Stopped Mode)

```bash
vzdump 302 --compress zstd --mode stop --storage local
```

Backup Container ID 101 (Snapshot Mode)

```bash
vzdump 101 --compress lzo --mode snapshot --storage nas_backup
```

`--compress`: `gzip` (standard), `lzo` (fast), `zstd` (best balance)

`--mode`:

- `stop` (service interruption, maximum consistency)
- `snapshot` (live backup, requires supported filesystem)

`--storage`: Target storage ID (view with `pvesm list`)

Multi LXC Backup

```bash
vzdump 100 101 102 --mode stop --storage local --compress zstd
```



------

#### **2.10 Restore a Container**

To restore a container from a backup, use the `pct restore` command.

```bash
pct restore <vmid> <backup-file> [options]
```

**Example:**

```bash
pct restore 100 /var/lib/vz/dump/vzdump-lxc-100-2023_10_01-12_00_01.tar.gz
```



#### **2.11 Destroy a Container**

To permanently delete a container.

```bash
pct destroy <vmid> --purge
```

- `<vmid>`: The ID of the container to be destroyed.
- `--purge`: Removes all associated data, including backups and configuration files.



**Example:**

```bash
pct destroy 100 --purge
```



------

### **3. Advanced Usage**

#### **3.1 Mount Host Directories**

Directories from the host can be mounted into the container.

**Example:**

```bash
pct set 100 --mp0 /mnt/host-data,/mnt/container-data,ro
```

------

#### **3.2 Configure Networking**

Static IPs or additional network interfaces can be configured.

**Example (Static IP):**

```bash
pct set 100 --net0 name=eth0,bridge=vmbr0,ip=192.168.1.100/24,gw=192.168.1.1
```

####  **Set VLAN** 

**Static IP Example:**

```bash
pct set 100 --net0 name=eth0,bridge=vmbr0,tag=10,ip=192.168.10.100/24,gw=192.168.10.1
```

> - Sets the VLAN tag to `10` for the `eth0` interface.
> - Connects the interface to the `vmbr0` bridge.
> - Assigns a static IP address `192.168.10.100/24` and gateway `192.168.10.1`.



**DHCP Example:**

```bash
pct set 100 --net0 name=eth0,bridge=vmbr0,tag=10,ip=dhcp
```

> - Multiple network interfaces can be configured by incrementing the `--netX` option (e.g., `--net1`, `--net2`).
> - Ensure the VLAN is properly configured on the Proxmox host's network bridge (e.g., `vmbr0` or `vmbr1`).



------

#### **3.3 Resource Limits**

CPU and memory limits can be set for the container.

**Example:**

```bash
pct set 100 --memory 4096 --cores 2
```

------

### **4. Troubleshooting**

- **Container Fails to Start**: Check logs using `pct logs <vmid>`.
- **Network Issues**: Verify the network configuration with `pct config <vmid>`.

------

### **5. Help and Documentation**

- Use `pct help` to see a list of available commands.
- For detailed documentation, use `man pct`.

------

### **6. Automate to creation of an LXC container in Proxmox VE (PVE).**

#### Script Overview

1. Prompts the user for input (LXC ID and password).
2. Checks if the LXC ID already exists and handles conflicts.
3. Downloads the LXC template if it doesn't already exist.
4. Creates a new LXC container with specified configurations.
5. Appends additional configuration to the container's configuration file.

```
wget -q https://kingtam.eu.org/scripts/lxc-create.sh -O lxc-create.sh && chmod +x lxc-create.sh && bash ./lxc-create.sh
```



------

### **Conclusion**

The `pct` command line tool is a powerful way to manage LXC containers in Proxmox VE. With this guide, creating, configuring, and managing containers efficiently should be straightforward. For further questions or assistance, additional resources are available in the Proxmox documentation.



---

### Related

- [Installing CUPS on PVE's LXC Container System](https://kingtam.eu.org/posts/pve-lxc-cups/)

- [Managing LXC in Proxmox Virtual Environment (PVE)](https://kingtam.eu.org/posts/pve-lxc/)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.eu.org/posts/alpine-lxc-docker/)
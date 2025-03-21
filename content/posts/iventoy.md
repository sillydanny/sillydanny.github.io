---
title: "Iventoy"
date: 2025-01-29T10:22:52+08:00
draft: false
author: "King Tam"
summary: ""
showToc: true
categories:
- Linux
tags:
- iPXE
- iVentoy
ShowLastMod: true
cover:
    image: "img/iventoy/Cover_iVentoy.jpeg"
---

### Introduction

> `iVentoy` is another convenient tool developed by the author ( `longpanda`) of the famous ISO boot tool `Ventoy`. The goal of this tool is to enable booting and startup through the PXE server without even preparing a flash drive, and the system is also very convenient to use. 

---

![iventoy](/img/iventoy/iventoy.png)

### Deploy

<table><tr align="left"><td bgcolor=#33B679><font size=4 color=white><b>SCENARIO01 (step-by-step)</b> </font></td></tr></table>

##### Download iVentoy

Please use the root privilege to run below commands

```bash
wget https://github.com/ventoy/PXE/releases/download/v1.0.20/iventoy-1.0.20-linux-free.tar.gz -O /tmp/iventoy.tar.gz
```

##### Extract the Package

```bash
tar -xvzf /tmp/iventoy.tar.gz -C /opt
```

##### Rename Directory

```bash
mv /opt/iventoy-1.0.20 /opt/iventoy
```

##### Remove the Downloaded Archive

```bash
rm /tmp/iventoy.tar.gz
```

##### Create systemd Service File

```bash
cat << EOF > /etc/systemd/system/iventoy.service
[Unit]
Description=iVentoy iPXE Server
Requires=network-online.target
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
User=root
Group=root
WorkingDirectory=$DEST_DIR
ExecStart=$DEST_DIR/iventoy.sh -R start
ExecStop=$DEST_DIR/iventoy.sh stop

[Install]
WantedBy=multi-user.target
EOF
```

##### Reload systemd to Recognize the New Service

```bash
systemctl daemon-reload
```

##### Enable the Service to Start on Boot

```bash
systemctl enable iventoy
```

##### Start the Service

```bash
systemctl start iventoy
```



**<mark><u>Execute all steps using a script (Option)</u></mark>**

```bash
bash -c "$(wget -qLO - https://kingtam.eu.org/scripts/iventoy-deploy.sh)"
```

---

<table><tr align="left"><td bgcolor=#33B679><font size=4 color=white><b>SCENARIO02 (iVentoy LXC On PVE)</b> </font></td></tr></table>

![2025-03-06_154315](/img/iventoy/2025-03-06_154315.png)

[iVentoy](https://www.iventoy.com/) is an enhanced version of the PXE server.

To create a new Proxmox VE iVentoy LXC, run the command below in the **Proxmox VE Shell**.

```bash
bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/iventoy.sh)"
```

⚡ Default Settings: 512MiB RAM - 2GB Storage - 1vCPU - Privileged 
⚡iVentoy Interface: IP:26000/

![2025-03-06_160828](/img/iventoy/2025-03-06_160828.png)

`/etc/systemd/system/iventoy.service`

```bash
[Unit]
Description=iVentoy PXE Booter
Documentation=https://www.iventoy.com
Wants=network-online.target
[Service]
Type=forking
Environment=IVENTOY_API_ALL=1
Environment=IVENTOY_AUTO_RUN=1
Environment=LIBRARY_PATH=/opt/iventoy/lib/lin64
Environment=LD_LIBRARY_PATH=/opt/iventoy/lib/lin64
ExecStart=sh ./iventoy.sh -R start
WorkingDirectory=/opt/iventoy
Restart=on-failure
[Install]
WantedBy=multi-user.target
```

---

<table><tr align="left"><td bgcolor=#33B679><font size=4 color=white><b>SCENARIO03 (Docker)</b> </font></td></tr></table>

A Docker image running [iVentoy⁠](https://www.iventoy.com/) 1.0.20.



It is necessary to create the following directories before running the Docker container.

```bash
mkdir -p iventoy/{data,iso,log,user}
```



| Directory | Mount point       | Description                                                  |
| :-------- | :---------------- | :----------------------------------------------------------- |
| `data`    | /opt/iventoy/data | For License file, config files.                              |
| `iso`     | /opt/iventoy/iso  | For ISO files.                                               |
| `log`     | /opt/iventoy/log  | For log files.                                               |
| `user`    | /opt/iventoy/user | For user files, third-part software, auto install scritps ... |

#### Docker Compose

```yaml
cat << EOF > docker-compose.yml
version: '3.9'
services:
  iventoy:
    image: szabis/iventoy:latest
    network_mode: "host"
    container_name: iventoy
    restart: always
    privileged: true #must be true
    environment:
      - AUTO_START_PXE=true
#    ports:
#      - "67:67/udp" # DHCP Server
#      - "69:69/udp" # TFTP Server
#      - "10809:10809" # NBD Server (NBD)
#      - "16000:16000" # PXE Service HTTP Server (iVentoy PXE Service)
#      - "26000:26000" # PXE GUI HTTP Server (iVentoy GUI)
    volumes:
      - ./data:/opt/iventoy/data
      - ./iso:/opt/iventoy/iso
      - ./log:/opt/iventoy/log
      - ./user:/opt/iventoy/user
      
EOF
```

Startup the Docker container

```bash
docker compose up -d
```



---

### Use iVentoy via GUI

iVentoy GUI is based on WEB, we could open browser and visit `http://x.x.x.x:26000` after you run iVentoy.

> (x.x.x.x is the IP address of the computer that run iVentoy)

![2025-01-28_103427](/img/iventoy/2025-01-28_103427.png)

##### Before start

For the directories:

| Directory | Description                                                  |
| :-------- | :----------------------------------------------------------- |
| data      | For License file, config files.                              |
| doc       | For document                                                 |
| iso       | For ISO files.                                               |
| lib       | For library files that needed by iVentoy. Don't put other files here. |
| log       | For log files.                                               |
| user      | For user files, third-part software, auto install scritps ... |

Copy all your ISO files to the `iso` directory. You can create subdirectories arbitrarily under this directory to classify and store ISO files.

![2025-01-28_105601](/img/iventoy/2025-01-28_105601.png)

>  Note: Ensure that there are no Unicode characters or spaces in the directory name or ISO file name.



##### Start PXE Service

Select server IP and set the IP pool, then click the green button to start PXE service.

![2025-01-28_103444](/img/iventoy/2025-01-28_103444.png)



---

### Third-part DHCP Server (Option)

`iVentoy` can also work together with external DHCP Server. such as ROS, OpenWrt or Windows DHCP Server , making system installation less troublesome and simplifying user troubles!

**External Mode**

In my case, I use the External Mode since the DHCP server is located in the same subnet.

![2025-01-28_103521](/img/iventoy/2025-01-28_103521.png)

MikroTik RouterOS (Sample)

![2025-01-28_103702](/img/iventoy/2025-01-28_103702.png)

Windows DHCP Server (Sample)

![2025-01-28_103941](/img/iventoy/2025-01-28_103941.png)

For `External` mode, set `bootfile` option value to `iventoy_loader_16000`

> Note that the suffix 16000 is the iVentoy http server port, if you change it on the page then the bootfile should match it. (For example: `iventoy_loader_17000`).

![2025-01-28_104026](/img/iventoy/2025-01-28_104026.png)

 **ExternalNet Mode**

The usage scenario of `ExternalNet` mode is that iVentoy and the third-party DHCP Server are located in different LANs/VLANs.

![2025-03-06_153210](/img/iventoy/2025-03-06_153210.png)

![2025-03-06_153255](/img/iventoy/2025-03-06_153255.png)

![2025-03-06_152516](/img/iventoy/2025-03-06_152516.png)

---

### iVentoy Auto Installation (Option)

To create an unattended deployment, we need to recreate a new ISO file based on the original ISO file and add the script or template into the new ISO file.

For Windows unattended deployment, use the [Windows Answer File Generator](https://www.windowsafg.com/). It is very simple and allows you to customize it as you want.

##### Configuration

In my case, I put the script in the path of the scripts directory: `/opt/iventoy/user/scripts`.

Select the corresponding ISO file on the iVentoy WEB GUI, and set the auto installation script path.

![2025-01-28_105913](/img/iventoy/2025-01-28_105913.png)

> "More than one script for an ISO file is acceptable.

---

### Start to deploy a system via iventoy

![2025-01-28_110406](/img/iventoy/2025-01-28_110406.png)

![2025-01-28_110422](/img/iventoy/2025-01-28_110422.png)

![2025-01-28_110608](/img/iventoy/2025-01-28_110608.png)

![2025-01-28_110827](/img/iventoy/2025-01-28_110827.jpg)

---

### Conclusion:

> Currently, most PCs and laptops have a built-in PXE boot function, often referred to as `Network Stack`. It is highly recommended for those who have a lot of system refilling requirements to give this function a try.
>
> Using `iVentoy`'s approach can significantly reduce the hassle when installing the system.



---

### Related:

[iPXE 網絡引導安裝](https://kingtam.win/archives/ipxe.html)

---

### Reference:

[iVentoy](https://www.iventoy.com/en/doc_edition.html)

[How to run in a systemd service](https://github.com/ventoy/PXE/issues/27)

[iVentoy LXC](https://tteck.github.io/Proxmox/)

[Docker Hub](https://hub.docker.com/r/szabis/iventoy)

[Windows Answer File Generator](https://www.windowsafg.com/)
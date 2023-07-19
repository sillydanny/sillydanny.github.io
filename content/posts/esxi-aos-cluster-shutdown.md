---
title: "How To Safely Shut Down Your ESXi and Nutanix (AOS) Cluster"
date: 2023-07-11T14:42:29+08:00
draft: false
author: "King Tam"
summary: "How To Safely Shut Down Your ESXi and Nutanix (AOS) Cluster" 
showToc: true
categories:
- ESXi
tags:
- AOS
- Nutanix
- cluster
- vCenter
- VMware
ShowLastMod: true
cover:
    image: "img/esxi-aos-cluster-shutdown/esxi-aos-cluster-shutdown.jpg"
---


### About

> Shut down all hosts in a Nutanix cluster that is running VMware ESXi for maintenance.
> **Note:** The procedure is designed to be executed only in the absence of `Metro`, `Async/NearSync`, and `Nutanix Files` services.

---



<table><tr><td bgcolor=#D0402F style="text-align: center; vertical-align: middle;"><font size=4 color=white><b>Power Off</b></font></td></tr></table>



<span id="1"></span>

#### 1. Run NCC Health Check via Nutanix Web Console

> **Note:** Upgrade to the latest version of NCC before proceeding with the following steps.

**<u>i.</u>** Upgrade NCC to latest version

![2023-07-06_132540](/img/esxi-aos-cluster-shutdown/2023-07-06_132540.png)

**<u>ii.</u>** Run NCC Health Check

![2023-07-06_132601](/img/esxi-aos-cluster-shutdown/2023-07-06_132601.png)

Check that everything is working well, then could proceed to the next step.



<span id="2"></span>

#### 2. Shut down All VMs in the vCenter

> **NOTE :** Do not shut down the Nutanix Controller VMs (CVM).

**<u>i.</u>** The **DRS** setting must be set to '`Manual`' before shutting down all VMs.

![2022-12-29_160831](/img/esxi-aos-cluster-shutdown/2022-12-29_160831.png)



**<u>ii.</u>** Start the process of shutting down all virtual machines using vCenter.



<span id="3"></span>

#### 3. Shut down the vCenter (VM)

<span id="vc"></span>

> **Note:** Remember the host on which the vCenter is currently running.
>
> `* Host will be assigned automatically based on the cluster, and their names should fall within the range of vms01-08.`

![2023-07-07_143216](/img/esxi-aos-cluster-shutdown/2023-07-07_143216.png)

**Method 1: Login - vCenter Server Management to shut down (via Browser)**

![2023-07-06_133219](/img/esxi-aos-cluster-shutdown/2023-07-06_133219.png)



**Method 2: To shut down via Remote Console**

![2023-07-06_133304](/img/esxi-aos-cluster-shutdown/2023-07-06_133304.png)



<span id="4"></span>

#### 4. Stop the Nutanix Cluster and Shut down CVM

**<u>i.</u>** Stop the Nutanix cluster

Log in to **one of** **CVM** using SSH and execute the following command to stop the Nutanix cluster:

~~~bash
 cluster stop
~~~

Wait until output similar to the following is displayed for every Controller VM in the cluster before proceeding:

![2023-07-07_143944](/img/esxi-aos-cluster-shutdown/2023-07-07_143944.png)

**<u>ii.</u>** Shut down CVM:

Log in to **each** **CVM** using SSH and execute the following command to shut down:

~~~bash
 sudo shutdown -P now
~~~



<span id="5"></span>

#### 5. Shut down each Node (Host)

**Method01: via GUI**

Log in to **each node** (ESXi) using a browser to follow the indicators.

**<u>i.</u>** Put host in maintenance mode:

![2023-07-07_150321](/img/esxi-aos-cluster-shutdown/2023-07-07_150321.png)

**<u>ii.</u>** Shut down the host:

![2023-07-07_150334](/img/esxi-aos-cluster-shutdown/2023-07-07_150334.png)



**Method02: via Command line**

Log in to **each Node** (ESXi) using SSH and execute the following command

**<u>i.</u>** Put host in maintenance mode:

~~~bash
 esxcli system maintenanceMode set --enable true
~~~

**<u>ii.</u>** Shut down the host:

~~~bash
 poweroff
~~~

---

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=4 color=white><b>Power On</b></font></td></tr></table>



<span id="6"></span>

#### 6. Powering on the Nodes and Cluster

> After the shutdown

**<u>i.</u>** Power On all Nodes via IPMI. (Or turn it on by pressing the physical power button on the front)

![2023-07-07_164950](/img/esxi-aos-cluster-shutdown/2023-07-07_164950.png)

**<u>ii.</u>** Log in to **each node** (ESXi) using a browser and select **Exit Maintenance Mode**.

![2023-07-07_150321](/img/esxi-aos-cluster-shutdown/2023-07-07_150321-1688971682024.png)

​	**Or**, log in to **each Node** using SSH and execute the following command

~~~bash
 esxcli system maintenanceMode set --enable false
~~~

**<u>iii.</u>** Log in the node that previous was recorded (e.g.[vms01](#vc)) , then Right-click the vCenter and select **Power** > **Power on**.

![2023-07-07_170424](/img/esxi-aos-cluster-shutdown/2023-07-07_170424.png)

​	**Or**, log in to the **Node** ([vms01](#vc)) using SSH and execute the following command

~~~bash
vim-cmd vmsvc/power.on "$(vim-cmd vmsvc/getallvms | grep -ia "vCenter" | cut -d ' ' -f 1)"
~~~

Wait for approximately 5 minutes for all services to start on the VM.



**<u>iv.</u>** Right-click each **CVM** and select **Power** > **Power on** via vCenter

![2023-07-07_171706](/img/esxi-aos-cluster-shutdown/2023-07-07_171706.png)

​	**Or**, log in to **Each** **Node** (ESXi) using SSH and execute the following command

~~~bash
vim-cmd vmsvc/power.on "$(vim-cmd vmsvc/getallvms | grep -ia "NTNX-*-CVM" | cut -d ' ' -f 1)"
~~~



<span id="7"></span>

#### 7. Start Nutanix Cluster

**<u>i.</u>** Log on to any of the CVMs in the cluster via SSH with the nutanix user credentials.

**<u>ii.</u>** Start the Nutanix cluster by issuing the following command:

```bash
cluster start
```

When the cluster starts, output similar to the following is displayed for each Controller VM in the cluster:

![2023-07-10_103716](/img/esxi-aos-cluster-shutdown/2023-07-10_103716.png)

**<u>iii.</u>** Confirm that all cluster services are running on the Controller VMs.

```bash
cluster status
```

> 2023-07-11 03:38:45,982Z INFO MainThread cluster:3088 Success! (*The last in line.)

**<u>iv.</u>** Confirm that all Nutanix datastores are available:

Right-click the ESXi host in the vSphere client and select **Rescan for Datastores**.

![2023-07-10_104707](/img/esxi-aos-cluster-shutdown/2023-07-10_104707.png)

<span id="8"></span>

#### 8. Start All VMs

**<u>i.</u>** Power On all virtual machines using vCenter.



**<u>ii.</u>** The **DRS** setting must be set to '`Fully Automated`' after **Power On** all VMs.

![2023-07-07_143123](/img/esxi-aos-cluster-shutdown/2023-07-07_143123.png)






---

### Reference

- [ESXi - Shutting down the cluster​ - Maintenance or Re-location](https://next.nutanix.com/how-it-works-22/esxi-shutting-down-the-cluster-maintenance-or-re-location-33732)
- [Shutting down Nutanix cluster running VMware vSphere for maintenance or relocation](https://portal.nutanix.com/page/documents/kbs/details?targetId=kA0600000008ctECAQ)
- [Shutting Down an ESXi Node in a Nutanix Cluster](https://portal.nutanix.com/page/documents/details?targetId=vSphere-Admin6-AOS-v6_5:vsp-node-shutdown-vcenter-vsphere-t.html)
- [Shutting Down a Node in a Cluster (vSphere Command Line)](https://portal.nutanix.com/page/documents/details?targetId=Hardware-Admin-Ref-AOS-v5_10:vsp-node-shutdown-vsphere-cli-t.html)
- [Failing Over a Protection Domain (Planned Failover)](https://portal.nutanix.com/page/documents/details?targetId=Prism-Element-Data-Protection-Guide-v:wc-metro-availability-failover-vmotion-t.html)

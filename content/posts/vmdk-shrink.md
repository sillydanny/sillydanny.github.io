---
title: "How to Shrink VMDK Virtual Disk Size on VMWare ESXi"
date: 2023-07-05T09:07:57+08:00
draft: false
author: "King Tam"
summary: "How to Shrink VMDK Virtual Disk Size on VMWare ESXi" 
showToc: true
categories:
- ESXi
tags:
- vmware
- shrink
ShowLastMod: true
cover:
    image: "img/vmdk-shrink/vmdk-shrink.png"
---


## Overview

> Expanding the capacity of VM disks is easy, but shrinking their size is not straightforward on VMWare ESXi GUI.
>
> Here, we will perform an action to reduce the disk size on VMWare ESXi using the command line.



---

## Step-by-Step Guide

### 1. Shutdown the VM

Power off the virtual machine that contains the virtual disk you want to shrink and note that all snapshots of the VM need to be deleted before starting the action.

### 2. Enable SSH service on VMWare ESXi

![2023-07-05_084829](/img/vmdk-shrink/2023-07-05_084829.png)

### 3. Shrink VMDK Size on VMWare ESXi

Login to ESXi SSH console via Putty or other SSH client software.

Enter the VM storage directory (e.g., "`/vmfs/volumes/Datastorage/`").

![2023-07-04_123622](/img/vmdk-shrink/2023-07-04_123622.png)

Edit the file named "`hostname.vmdk`" using a text editor (e.g. `vi VM_TEST.vmdk`).

In this case, the edited file was "`VM_TEST.vmdk`".

![2023-07-04_123631](/img/vmdk-shrink/2023-07-04_123631.png)

Locate the "`# Extent description`" of the content, which is shown below:

```
# Extent description
RW 209715200 VMFS "VM_TEST-flat.vmdk"
```

Suppose the VM's HDD current size is 100GB, which is equivalent to 209715200 of content. We would like to reduce the size by 40GB, which means shrinking it to 60GB. The new content number is "209715200 - (40\*1024\*1024) = **125829120**".

Update the content of VM_TEST.vmdk to:

![2023-07-04_123657](/img/vmdk-shrink/2023-07-04_123657.png)

```
RW 125829120 VMFS "VM_TEST-flat.vmdk"
```

Save and close the text editor.

### 4. Start the VM

Power on the virtual machine and log in to the guest OS.

Open the "**Disk Management**".

![2023-07-04_124340](/img/vmdk-shrink/2023-07-04_124340.png)

![2023-07-04_124422](/img/vmdk-shrink/2023-07-04_124422.png)

The volume size is still 100GB, so take a "Shrink Volume..." action of the virtual disk.

![2023-07-04_124440](/img/vmdk-shrink/2023-07-04_124440.png)

Now, the virtual disk has been successfully shrunk to the new size.

### 5. Fix the Display Size (Optional)

<u>*Issue:*</u>

![2023-07-04_130113](/img/vmdk-shrink/2023-07-04_130113.png)

The STORAGE of the instance still displays 100GB, but the actual size has been shrunk to 60GB.

<u>*Solution:*</u>

To fix this, export and import the VM by `OVF TOOL`.

#### Export the VM

```bash
ovftool.exe vi://root:"P@ssw0rd"@vms01/VM_TEST c:\tools\VM_TEST.ova
```

#### Import the VM

```bash
ovftool.exe --sourceType=OVA -n=VM_TEST -ds=Datastorage "c:\tools\VM_TEST.ova" vi://root:"P@ssw0rd"@vms01
```

---

### Conclusion

>  To shrink the size of a VMDK virtual disk on VMWare ESXi using the command line. The guide is easy to follow but caution should be exercised and backups should be made before proceeding with the steps.

---


### Reference

- [Shrink VMDK Virtual Disk Size on VMWare ESXi - How to do it ](https://bobcares.com/blog/shrink-vmdk-virtual-disk-size-on-vmware-esxi/#:~:text=From%20the%20down%20arrow%20key%2C%20go%20to%20the,its%20virtual%20disk%20will%20display%20in%20its%20properties.)

---

### Related

- [Manual Upgrade ESXi from 6.7 to 8.0 via esxcli](https://kingtam.eu.org/posts/esxi-upgrade/)
- [Renew DNS Servers in VMWare ESXi via ESXCLI Commands](https://kingtam.eu.org/posts/esxi-dns-update/)
- [Deploy a Virtual Machine from an OVA File in the VMware ESXi](https://kingtam.eu.org/posts/esxi-deploy-vm/)
- [Export VM to OVA using OVF Tool on VMware ESXi](https://kingtam.eu.org/posts/ova-export/)

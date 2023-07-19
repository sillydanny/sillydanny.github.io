---
title: "Use the Veeam Backup & Replication to P2V"
date: 2023-06-30T15:34:19+08:00
draft: false
author: "King Tam"
summary: "Use the Veeam Backup & Replication to P2V" 
showToc: true
categories:
- Windows
tags:
- P2V
- Veeam
- VM
ShowLastMod: true
cover:
    image: "img/veeam-p2v/veeam-p2v.jpg"
---

### Overview:

>  We can use the Veeam Backup & Replication restore function to perform a physical to virtual (P2V) backup to a virtual machine (VM).

>  This restores a backup of a physical server or workstation to a virtual machine, let us run the system as a VM on virtualization platform.

---

### Involved Procedures:

#### Instant Recovery:

  > This process quickly recovers a VM from a backup.

Restoring the VM to a production-ready state, which likes a sandbox environment, We can access and use the VM while the restore process continues in the background.

![2023-03-21_091030](/img/veeam-p2v/2023-03-21_091030.png)

![2023-03-21_091037](/img/veeam-p2v/2023-03-21_091037.png)

![2023-03-21_091043](/img/veeam-p2v/2023-03-21_091043.png)

![2023-03-21_091051](/img/veeam-p2v/2023-03-21_091051.png)

![2023-03-21_091217](/img/veeam-p2v/2023-03-21_091217.png)

![2023-03-21_091253](/img/veeam-p2v/2023-03-21_091253.png)

![2023-03-21_091301](/img/veeam-p2v/2023-03-21_091301.png)

![2023-03-21_091306](/img/veeam-p2v/2023-03-21_091306.png)

![2023-03-21_091332](/img/veeam-p2v/2023-03-21_091332.png)

![2023-03-21_091352](/img/veeam-p2v/2023-03-21_091352.png)

![2023-03-21_094602](/img/veeam-p2v/2023-03-21_094602.png)

![2023-03-21_161641](/img/veeam-p2v/2023-03-21_161641.png)

> In `Instant Recovery` mode, the disk with data is still stored in Veeam Backup.

Once the restore process is complete, the VM can be migrated to the production environment.



---



#### Migrate to Production:

  >  Once the VM has been restored and is in a production-ready state, you can migrate it to the production environment.

This process copies the VM to its final location and performs any necessary configuration changes to ensure it is appropriately migrated into the production environment.

![2023-03-21_162619](/img/veeam-p2v/2023-03-21_162619.png)

![2023-03-23_140252](/img/veeam-p2v/2023-03-23_140252.png)

![2023-03-23_140310](/img/veeam-p2v/2023-03-23_140310.png)

![2023-03-23_140410](/img/veeam-p2v/2023-03-23_140410.png)

![2023-03-23_145803](/img/veeam-p2v/2023-03-23_145803.png)

![2023-03-24_075521](/img/veeam-p2v/2023-03-24_075521.png)

![2023-03-24_150228](/img/veeam-p2v/2023-03-24_150228.png)

> After `Migrate to Production`, the disk with data is completely copied to the VM server.

Once the migration is complete, the VM is fully operational and can be used as normal.

---

### Summary

> `Instant recovery` is used when you need to quickly restore a VM to its original location or a new location for temporary use, while `migrate to production` is used when you need to permanently move a VM to a new location in your virtual environment.

---
title: "Manual Upgrade ESXi from 6.7 to 8.0 via esxcli"
date: 2023-06-03T14:38:12+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- ESXi
tags:
- vmware 
- esxcli
ShowLastMod: true
cover:
    image: "img/esxi-upgrade/esxi-upgrade.png"
---

# Manual Upgrade ESXi from 6.7 to 8.0 via esxcli



<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Preparation:</b></font></td></tr></table>

> Before deploying a host upgrade, ensure that all virtual machines in this host should be shut down and [Back Up VMware ESXi Host Configuration](https://www.nakivo.com/blog/back-up-and-restore-vmware-esxi-host-configuration-guide/).

- Download the upgrade file from [VMware Official](https://customerconnect.vmware.com/downloads/#all_products)

There are two types of upgrade files

- The `.iso` is bootable and follow instructions.
- The `.zip` is upgraded via SSH using CLI commands.

> In this scenario, I use Offline Bundle (.zip) to upgrade host.

---

---
<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Upgrade Path</b></font></td></tr></table>



> Running ESXi 6.7U(1-3) or ESXi 7.0U(1-3), you can upgrade directly from these versions to ESXi 8.0.

![UpgradePath](/img/esxi-upgrade/UpgradePath.png)

From: [Product Interoperability Matrix (vmware.com)](https://interopmatrix.vmware.com/Upgrade?productId=1&isHidePatch=true)

---



<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Upgrade Procedure:</b></font></td></tr></table>

<table><tr align="left"><td bgcolor=#25add7><font size="3" color=white><b>From ESXi 6.7 to ESXi 6.7U3</b> </font></td></tr></table>


| Hypervisor | Before            | After          |
| ---------- | ----------------- | -------------- |
| ESXi       | VMware ESXi 6.7.0 | 6.7.0 Update 3 |

![2022-12-28_150342](/img/esxi-upgrade/2022-12-28_150342.png)

Upload the upgrade file(`ESXi670-201912001.zip`) to a datastore

The file location: <mark>`/vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/ESXi670-201912001.zip`</mark>

![2022-12-28_151805](/img/esxi-upgrade/2022-12-28_151805.png)

Enable SSH Service

Put the node into maintenance mode

> connect to console via SSH.

~~~bash
vim-cmd hostsvc/maintenance_mode_enter
~~~

![2022-12-28_150716](/img/esxi-upgrade/2022-12-28_150716.png)

View the image profiles

> Connect to the console via SSH and run the following command to check the image profile.

~~~bash
esxcli software sources profile list -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/ESXi670-201912001.zip
~~~

![2022-12-28_150608](/img/esxi-upgrade/2022-12-28_150608.png)

![2022-12-28_150100](/img/esxi-upgrade/2022-12-28_150100.png)

Compared to the existing image profile `ESXi-6.7.0-8169922-standard (VMware, Inc.)`, the upgrade profile name `ESXi-6.7.0-20191204001-standard` should be selected.



Run upgrade and append the profile name (`ESXi-6.7.0-20191204001-standard`) at the end of the command.

~~~bash
esxcli software profile update -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/ESXi670-201912001.zip -p ESXi-6.7.0-20191204001-standard
~~~

![2022-12-28_150910](/img/esxi-upgrade/2022-12-28_150910.png)

When see the message: `The Update completed successfully`

The upgrade is completed and a **<mark>reboot</mark>** is required for the changes to take effect.

Finally, exit maintenance mode in the node after reboot.

```bash
vim-cmd hostsvc/maintenance_mode_exit
```

![2022-12-28_150748](/img/esxi-upgrade/2022-12-28_150748.png)

---

<table><tr align="left"><td bgcolor=#25add7><font size="3" color=white><b>From ESXi 6.7U3 to ESXi 7.0 U3</b> </font></td></tr></table>


| Hypervisor | Before         | After        |
| ---------- | -------------- | ------------ |
| ESXi       | 6.7.0 Update 3 | 7.0 Update 3 |

![2022-12-28_151817](/img/esxi-upgrade/2022-12-28_151817.png)

Upload the upgrade file(`VMware-ESXi-7.0U3g-20328353-depot.zip`) to a datastore

The file location: <mark>`/vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-7.0U3g-20328353-depot.zip`</mark>

![2022-12-28_151805](/img/esxi-upgrade/2022-12-28_151805.png)

Enable SSH Service

Put the node into maintenance mode

> connect to console via SSH.

~~~bash
vim-cmd hostsvc/maintenance_mode_enter
~~~



View the image profiles

> Connect to the console via SSH and run the following command to check the image profile.

~~~bash
esxcli software sources profile list -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-7.0U3g-20328353-depot.zip
~~~

![2022-12-28_152115](/img/esxi-upgrade/2022-12-28_152115.png)

![2022-12-28_151948](/img/esxi-upgrade/2022-12-28_151948.png)

Compared to the existing image profile `(Updated) ESXi-6.7.0-20191204001-standard (VMware, Inc.)`, the upgrade profile name `ESXi-7.0U3g-20328353-standard` should be selected.



Run upgrade and append the profile name (`ESXi-7.0U3g-20328353-standard`) at the end of the command.

~~~bash
esxcli software profile update -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-7.0U3g-20328353-depot.zip -p ESXi-7.0U3g-20328353-standard
~~~

![2022-12-28_152246](/img/esxi-upgrade/2022-12-28_152246.png)

When see the message: `The Update completed successfully`

The upgrade is completed and a **<mark>reboot</mark>** is required for the changes to take effect.

Finally, exit maintenance mode in the node after reboot.

```bash
vim-cmd hostsvc/maintenance_mode_exit
```

---

<table><tr align="left"><td bgcolor=#25add7><font size="3" color=white><b>From ESXi 7.0 U3 to ESXi 8.0</b> </font></td></tr></table>


| Hypervisor | Before       | After |
| ---------- | ------------ | ----- |
| ESXi       | 7.0 Update 3 | 8.0   |

![2022-12-28_154037](/img/esxi-upgrade/2022-12-28_154037.png)

Upload the upgrade file(`VMware-ESXi-8.0-20513097-depot.zip`) to a datastore

The file location: <mark>`/vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-8.0-20513097-depot.zip`</mark>

![2022-12-28_151805](/img/esxi-upgrade/2022-12-28_151805.png)

Enable SSH Service

Put the node into maintenance mode

> connect to console via SSH.

~~~bash
vim-cmd hostsvc/maintenance_mode_enter
~~~



View the image profiles

> Connect to the console via SSH and run the following command to check the image profile.

~~~bash
esxcli software sources profile list -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-8.0-20513097-depot.zip
~~~

![2022-12-28_155042](/img/esxi-upgrade/2022-12-28_155042.png)

![2022-12-28_154958](/img/esxi-upgrade/2022-12-28_154958.png)

Compared to the existing image profile `(Updated) ESXi-7.0U3g-20328353-standard (VMware, Inc.)`, the upgrade profile name `ESXi-8.0.0-20513097-standard` should be selected.

---

![2022-12-30_152853](/img/esxi-upgrade/2022-12-30_152853.png)

If RAM capacity no match a minimum requires, the upgrade will be failed.

![2022-12-28_155236](/img/esxi-upgrade/2022-12-28_155236.png)

So, I Upgrade the RAM from 4 GB to 8 GB

![2022-12-28_160738](/img/esxi-upgrade/2022-12-28_160738.png)

---

Run upgrade and append the profile name (`ESXi-8.0.0-20513097-standard`) at the end of the command.

~~~bash
esxcli software profile update -d /vmfs/volumes/63abe767-b0668188-650d-005056b5b2ef/VMware-ESXi-8.0-20513097-depot.zip -p ESXi-8.0.0-20513097-standard
~~~

![2022-12-28_161113](/img/esxi-upgrade/2022-12-28_161113.png)

When see the message: `The Update completed successfully`

The upgrade is completed and a **<mark>reboot</mark>** is required for the changes to take effect.

Finally, exit maintenance mode in the node after reboot.

```bash
vim-cmd hostsvc/maintenance_mode_exit
```

![2022-12-28_161708](/img/esxi-upgrade/2022-12-28_161708.png)

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Conclusions:</b></font></td></tr></table>

> Using the command line interface to Upgrade by ESXCLI. This method can be used for standalone ESXi hosts and ESXi hosts managed by vCenter.

---

<table><tr align="left"><td bgcolor=#33B679><font size="4" color="white"><b>Related:</b></font></td></tr></table>

- [Manual Upgrade ESXi from 6.7 to 8.0 via esxcli](https://kingtam.eu.org/posts/esxi-upgrade/)
- [Renew DNS Servers in VMWare ESXi via ESXCLI Commands](https://kingtam.eu.org/posts/esxi-dns-update/)
- [Deploy a Virtual Machine from an OVA File in the VMware ESXi](https://kingtam.eu.org/posts/esxi-deploy-vm/)
- [Export VM to OVA using OVF Tool on VMware ESXi](https://kingtam.eu.org/posts/ova-export/)

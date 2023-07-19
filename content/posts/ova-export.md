---
title: "Export VM to OVA using OVF Tool on VMware ESXi"
date: 2023-07-04T16:15:25+08:00
draft: false
author: "King Tam"
summary: "Export VM to OVA using OVF Tool on VMware ESXi" 
showToc: true
categories:
- ESXi
tags:
- OVFTOOL
- OVA
- vmware
ShowLastMod: true
cover:
    image: "img/ova-export/ova-export.png"
---


## Web Export Limitations

> Utilizing the OVF Tool to export VMs as OVA files is the ideal solution to circumvent timeout issues that may arise when the VM size exceeds 2GB.

---

## Install the Latest OVF Tool

> The most recent OVF Tool version may help reduce errors, such as "`Error: cURL error: SSL connect error`".

Download the VMware OVF tool from the [VMware website](https://developer.vmware.com/web/tool/4.4.0/ovf).

---

## List VMs on Host using OVF Tool

Navigate to the OVF Tool directory in CMD (Administrator mode)

```bash
cd “C:\Program Files\VMware\VMware OVF Tool”
```

```bash
ovftool.exe vi://vms01.com.hk
```

OR

~~~bash
ovftool.exe vi://root:"P@ssw0rd"@vms01.com.hk
~~~

| Parameter    | Description            |
| ------------ | ---------------------- |
| root         | Host login account     |
| P@ssw0rd     | Host login password    |
| vms01.com.hk | Hostname or IP address |

![2023-07-04_104837](/img/ova-export/2023-07-04_104837.png)



> The list of VMs available for export to OVA is displayed.

---

## Export VM to OVA using OVF Tool

```bash
ovftool.exe  vi://root:"P@ssw0rd"@vms01.com.hk/VM_TEST c:\tools\VM_TEST.ova
```

> "`c:\tools\VM_TEST.ova`":  it will be saved as "`VM_TEST.ova`" in the "`c:\tools`\" directory.

![2023-07-04_130403](/img/ova-export/2023-07-04_130403.png)



---

## Import the OVA for Test

```bash
ovftool.exe  --sourceType=OVA  -n=VM_TEST -ds=Datastorage "c:\tools\Win2019SE.ova" vi://root:"P@ssw0rd"@vms01.com.hk
```

| Parameter        | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| --sourceType=OVA | Specifies the type of the source file (OVA format)           |
| -n=VM_TEST       | Specifies the name of the target virtual machine or appliance (VM_TEST) |
| -ds=Datastorage  | Specifies the target datastore for deployment (Datastorage)  |

![2023-07-04_131047](/img/ova-export/2023-07-04_131047.png)

![2023-07-04_130113](/img/ova-export/2023-07-04_130113.png)

---

### Conclusion

> Using the OVF tool, you can package a VM or virtual appliance into a single file that includes the VM configuration settings, disk images, and other necessary files. This file can then be deployed to any VMWARE environment that supports the OVF format, allowing for easy migration and distribution of VMs.

---

### Reference

- [Export VM to OVA or OVF using OVF Tool – The Ultimate Guide](https://www.vmwarearena.com/export-vm-to-ova-or-ovf-using-ovf-tool/)


---

### Related

- [Manual Upgrade ESXi from 6.7 to 8.0 via esxcli](https://kingtam.eu.org/posts/esxi-upgrade/)
- [Renew DNS Servers in VMWare ESXi via ESXCLI Commands](https://kingtam.eu.org/posts/esxi-dns-update/)
- [Deploy a Virtual Machine from an OVA File in the VMware ESXi](https://kingtam.eu.org/posts/esxi-deploy-vm/)
- [Export VM to OVA using OVF Tool on VMware ESXi](https://kingtam.eu.org/posts/ova-export/)

---
title: "Deploy a Virtual Machine from an OVA File in the VMware ESXi"
date: 2023-06-12T11:40:21+08:00
draft: false
author: "King Tam"
summary: "" 
showToc: true
categories:
- ESXi
tags:
- OVFTOOL
- OVA
- vmware
ShowLastMod: true
cover:
    image: "img/esxi-deploy-vm/esxi-deploy-ova.png"
---

Deploy a Virtual Machine from an OVA File in the VMware ESXi

### Web Deploy Limitation

> OVA deployment is limited to files under 1 GB in size due to Web browser limitations. To deploy an OVA file greater than 1 GB, extract the OVA file using tar and provide the OVF and VMDK files separately.

---

### Breakdown Limitation

> To deploy a large OVA file, Use `OVFTool` Command to Deploy OVA Packages is better solution.


---

### Deploy a VM via OVFTOOL

> In this scenario, `OVFTool` has been installed in windows OS. Open command prompt and run as administrator. go to the VMware OVF Tool directory "`C:\Program Files\VMware\VMware OVF Tool`"

![2023-06-12_111703](/img/esxi-deploy-vm/2023-06-12_111703.png)

Run the command syntax to deploy OVA

```
ovftool --sourceType=OVA --acceptAllEulas --X:skipContentLength --disableVerification --noSSLVerify -ds=DataStore -n=NEWVM --net:"network=VM Network" "D:\tmp\OVA_import\a-large-ova-file.ova" vi://root:"P@ssw0rd"@10.10.10.254
```

| Option | Argument | Description |
| ------ | -------- | ----------- |
| `ovftool` | N/A | Command to invoke the OVF Tool. |
| `--sourceType` | `OVA` | Specifies the type of the source file. In this case, it is an OVA file. |
| `--acceptAllEulas` | N/A | Skips the end user license agreement (EULA) acceptance prompt. |
| `--X:skipContentLength` | N/A | Skips the content length check during upload. |
| `--disableVerification` | N/A | Disables SSL certificate verification. |
| `--noSSLVerify` | N/A | Disables SSL certificate verification. |
| `-ds` | `DataStore` | Specifies the name of the destination datastore. |
| `-n` | `NEWVM` | Specifies the name of the new virtual machine. |
| `--net` | `"network=VM Network"` | Specifies the name of the network to which the virtual machine will be connected. |
| `"D:\tmp\OVA_import\a-large-ova-file.ova"` | N/A | Specifies the path to the OVA file to be imported. |
| `vi://root:"P@ssw0rd"@10.10.10.254` | N/A | Specifies the target location of the new virtual machine. |


> Note: The values for `DataStore`, `NEWVM`, `VM Network`, and the target location may vary depending on the specific environment and requirements.


#### No network mapping issue

> This problem occurred because we didn't know the OVA network or didn't remember it, which caused the network mapping issue.

![2023-06-12_101931](/img/esxi-deploy-vm/2023-06-12_101931.png)

> Opening OVA source: D:\tmp\OVA_import\a-large-ova-file.ova
> The manifest validates
> Opening VI target: vi://root@10.10.10.254:443/
> <mark>Error: Invalid OVF name (data  mgmt) specified in net mapping. OVF networks:   **<u>data</u>**  **<u>mgmt</u>**. Target networks:   CVM_Payload  VM Network  VM Network 2  svm-iscsi-pg</mark>
> Completed with errors


#### Re-mapping the network

> The fix involves specifying the correct network names in the mapping using the --net option. To do this, use the syntax --net:"`ovf_network_name=target_network_name`".

~~~
--net:"data=VM Network" --net:"mgmt=VM Network 2"
~~~

>  In this case, the OVA network names are "**<u>data</u>**" and "**<u>mgmt</u>**", which should be mapped to "VM Network" and "VM Network 2".


Run the correct (final) command syntax to deploy OVA

~~~
C:\Program Files\VMware\VMware OVF Tool>ovftool  --sourceType=OVA --acceptAllEulas --X:skipContentLength --disableVerification --noSSLVerify -ds=DataStore -n=NEWVM --net:"data=VM Network" --net:"mgmt=VM Network 2" "D:\tmp\OVA_import\a-large-ova-file.ova" vi://root:"P@ssw0rd"@10.10.10.254
~~~

![2023-06-12_101649](/img/esxi-deploy-vm/2023-06-12_101649.png)

> Opening OVA source: D:\tmp\OVA_import\a-large-ova-file.ova
> The manifest validates
> Opening VI target: vi://root@10.10.10.254:443/
> Deploying to VI: vi://root@10.10.10.254:443/
> Transfer Completed
> **Completed successfully**

---

### Reference

- [Deploy a Virtual Machine from an OVF or OVA File in the VMware Host Client](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-esxi-host-client/GUID-FBEED81C-F9D9-4193-BDCC-CC4A60C20A4E_copy.html)
- [OVFTOOL Download](https://customerconnect.vmware.com/tmp/get-download?downloadGroup=OVFTOOL443)
- [OVF Tool Command Syntax to Export and Deploy OVA/OVF Packages (1038709)](https://kb.vmware.com/s/article/1038709)
- [OVFtool error: No network mapping specified](https://github.com/josenk/terraform-provider-esxi/issues/103)

---

### Related

- [Manual Upgrade ESXi from 6.7 to 8.0 via esxcli](https://kingtam.eu.org/posts/esxi-upgrade/)
- [Renew DNS Servers in VMWare ESXi via ESXCLI Commands](https://kingtam.eu.org/posts/esxi-dns-update/)
- [Deploy a Virtual Machine from an OVA File in the VMware ESXi](https://kingtam.eu.org/posts/esxi-deploy-vm/)
- [Export VM to OVA using OVF Tool on VMware ESXi](https://kingtam.eu.org/posts/ova-export/)

---
title: "Renew DNS Servers in VMWare ESXi via ESXCLI Commands"
date: 2023-06-02T16:34:07+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- ESXi
tags:
- vmware
- dns
- esxcli
ShowLastMod: true
cover:
    image: "img/esxi-dns-update/esxi-dns-update.jpg"
---

# Renew DNS Servers in VMWare ESXi via ESXCLI Commands


### About Issue
> If you need to renew DNS servers on an ESXi host and are having trouble finding the DNS field in the ESXi portal, you can use ESXCLI commands to update the DNS servers.

---

### Procedure
1. Enable SSH Service first on ESXi

![](/img/esxi-dns-update/2023-06-02_140843.png)

2. Open a console or SSH session to the ESXi host.

~~~bash
ssh root@esxi_ip_address
~~~

3. List Current DNS server IP Address
Run the command

~~~bash
esxcli network ip dns server list
~~~

>   DNSServers: 10.1.1.253, 10.1.1.254

4. Add new DNS server IP address
> In this scenario, I use 1.1.1.1 and 1.0.0.1 as the new DNS server address.

~~~bash
esxcli network ip dns server add --server=1.1.1.1
esxcli network ip dns server add --server=1.0.0.1
~~~

5. Remove the exsiting (old) DNS address
> Refer to previous list the DNS address (10.1.1.253, 10.1.1.254)

~~~bash
esxcli network ip dns server remove --server=10.1.1.253
esxcli network ip dns server remove --server=10.1.1.254
~~~

6. List Current DNS server IP Address after update.

~~~bash
esxcli network ip dns server list
~~~

>   DNSServers: 1.1.1.1, 1.0.0.1

7. Finally diable SSH Service on ESXi

![](/img/esxi-dns-update/2023-06-02_141137.png)

---

### Conclusion

> Using the ESXCLI commands to update DNS servers is particularly useful when the DNS field is not easily accessible in the ESXi portal, or when there are a large number of ESXi hosts to update.


---

### Reference

- [VMWare ESXi ESXCLI Commands to Update Host DNS Servers](https://blog.techygeekshome.info/2021/04/vmware-esxi-esxcli-commands-to-update-host-dns-servers/)

---

### Related

- [Manual Upgrade ESXi from 6.7 to 8.0 via esxcli](https://kingtam.eu.org/posts/esxi-upgrade/)
- [Renew DNS Servers in VMWare ESXi via ESXCLI Commands](https://kingtam.eu.org/posts/esxi-dns-update/)
- [Deploy a Virtual Machine from an OVA File in the VMware ESXi](https://kingtam.eu.org/posts/esxi-deploy-vm/)
- [Export VM to OVA using OVF Tool on VMware ESXi](https://kingtam.eu.org/posts/ova-export/)

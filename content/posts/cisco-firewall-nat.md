---
title: "Setting up NAT (Port Forwarding) on Cisco ASA 5512-X (based on ASDM)"
date: 2023-06-17T11:01:02+08:00
draft: false
author: "King Tam"
summary: "Setting up NAT (Port Forwarding) on Cisco ASA 5512-X (based on ASDM)" 
showToc: true
categories:
- Network
tags:
- cisco
- firewall
- nat
- Port Forwarding
ShowLastMod: true
cover:
    image: "/img/cisco-firewall-nat/cisco-firewall-nat.jpg"
---


### Introduction:

> The Cisco ASA firewall can be challenging to work with, and using the CLI can be difficult. However, basic configuration can still be done using the ASDM GUI. Since I don't have a lot of time and energy to research the Cisco ASA firewall in-depth, I'm documenting the setup steps to avoid having to start from scratch again after a long time.
>
> In this example, we will configure NAT (Port Forwarding) for three NVR (CCTV recorders) on the Cisco ASA 5512-X firewall to allow access from the outside network. Details are shown in the following diagram.

---

![Cisco_ASA_NAT](/img/cisco-firewall-nat/Cisco_ASA_NAT-1686969112610.png)

---

### Configuration Example:

> Screenshots with minimal annotations.

##### Objects

- Network Objects (Creating network objects)

![ADD_2022-01-19_104308](/img/cisco-firewall-nat/ADD_2022-01-19_104308-1686969112610.png)

![NR01_2022-01-19_104042](/img/cisco-firewall-nat/NR01_2022-01-19_104042-1686969112610.png)

![NR02_2022-01-19_104048](/img/cisco-firewall-nat/NR02_2022-01-19_104048-1686969112610.png)

![NR03_2022-01-19_104053](/img/cisco-firewall-nat/NR03_2022-01-19_104053-1686969112610.png)

![ALL_2022-01-19_104141](/img/cisco-firewall-nat/ALL_2022-01-19_104141-1686969112611.png)



- Service Objects (Creating service objects)

![ADD_Services_2022-01-19_091348](/img/cisco-firewall-nat/ADD_Services_2022-01-19_091348-1686969112611.png)

![Port_Internal_2022-01-19_104015](/img/cisco-firewall-nat/Port_Internal_2022-01-19_104015-1686969112611.png)

![Port_Public01_2022-01-19_104023](/img/cisco-firewall-nat/Port_Public01_2022-01-19_104023-1686969112611.png)

![Port_Public02_2022-01-19_104028](/img/cisco-firewall-nat/Port_Public02_2022-01-19_104028-1686969112611.png)

![Port_Public03_2022-01-19_104034](/img/cisco-firewall-nat/Port_Public03_2022-01-19_104034-1686969112611.png)

![ALL_Services_2022-01-19_104143](/img/cisco-firewall-nat/ALL_Services_2022-01-19_104143-1686969112612.png)


---

##### NAT Rules

> Creating NAT rules using `Objects`.

![NAT01_2022-01-19_104406](/img/cisco-firewall-nat/NAT01_2022-01-19_104406-1686969112612.png)

Public_37 (Network Object) is the previously created Public IP address 209.118.222.13.

![NAT02_2022-01-19_104412](/img/cisco-firewall-nat/NAT02_2022-01-19_104412-1686969112612.png)

![NAT03_2022-01-19_104417](/img/cisco-firewall-nat/NAT03_2022-01-19_104417-1686969112612.png)

![NAT_ALL_2022-01-19_104358](/img/cisco-firewall-nat/NAT_ALL_2022-01-19_104358-1686969112612.png)



---

##### Access Rules

> Access rules are necessary to allow access from the outside network to the internal devices.

![Access_Rule01_2022-01-19_104428](/img/cisco-firewall-nat/Access_Rule01_2022-01-19_104428-1686969112612.png)

![Access_Rule02_2022-01-19_104433](/img/cisco-firewall-nat/Access_Rule02_2022-01-19_104433-1686969112616.png)

---

### Conclusion:

> This example covers the basic configuration of the ASA firewall, with a focus on understanding the basic relationship between `Objects`, `NAT`, and `Access Rules`. This will make it easier to configure firewalls from different vendors in the future.

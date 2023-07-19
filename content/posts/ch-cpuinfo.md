---
title: "Update CPU information on non-official Synology DSM system with ease"
date: 2023-07-13T13:14:48+08:00
draft: false
author: "King Tam"
summary: "Update CPU information on non-official Synology DSM system with ease" 
showToc: true
categories:
- 
tags:
- Synology
- DSM
- ch_cpuinfo
ShowLastMod: true
cover:
    image: "img/ch-cpuinfo/ch-cpuinfo.png"
---



### About

The FOXBI's `ch_cpuinfo` is shell script , which retrieve information about the CPU on a Synology DSM system.
The script obtains a summary of the CPU information, including the processor type, number of cores, clock speed, code-name e.g. `Haswell `, `Broadwell `, `Skylake `, `Kaby Lake` etc.

---

### How to Use

1. Connect to DSM terminal via SSH with privileged permission.

~~~bash
sudo -i
~~~

2. Download the `ch_cpuinfo` tar file from GitHub

~~~bash
wget https://github.com/FOXBI/ch_cpuinfo/releases/download/ch_cpuinfo/ch_cpuinfo.tar
~~~

![2023-07-06_101746](/img/ch-cpuinfo/2023-07-06_101746.png)


3. Decompress the tar file and grant execute permission.

~~~bash
tar -xvf ch_cpuinfo.tar && chmod -x ch_cpuinfo
~~~



![2023-07-06_101813](/img/ch-cpuinfo/2023-07-06_101813.png)


4. Execute the Script

~~~bash
./ch_cpuinfo
~~~



The script retrieves information; choose the options as needed.

![2023-07-06_102014](/img/ch-cpuinfo/2023-07-06_102014.png)

5. Re-login DSM to refresh the Info Center.

Before:

![2023-07-06_101258](/img/ch-cpuinfo/2023-07-06_101258.png)

After:

![2023-07-06_102124](/img/ch-cpuinfo/2023-07-06_102124.png)

---

### Conclusion

This script can be useful for those who need to update CPU information on a Syonlogy DSM installed on a non-official machine with a different CPU type.

---

### Related:

- [FOXBI's ch_cpuinfo](https://github.com/FOXBI/ch_cpuinfo)
- [Automating DSM VM Creation on Proxmox VE with a Bash Script](https://kingtam.eu.org/posts/pve-dsm/)

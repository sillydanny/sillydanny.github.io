---
title: "Cisco - Reset  Router to Factory Default Settings"
date: 2023-06-15T09:08:32+08:00
draft: false
author: "King Tam"
summary: "Cisco - Reset  Router to Factory Default Settings" 
showToc: true
categories:
- Network
tags:
- cisco
- switch
- router
- reset
ShowLastMod: true
cover:
    image: "img/cisco-reset/cisco-reset.jpg"
---



### Interduction:

> All exercises are based on the "Cisco Packet Tracer" software platform.

---

### Command line reset router:

![2021-09-17_151825](/img/cisco-reset/2021-09-17_151825.png)

~~~ruby
R1>enable
~~~

> Enter privilege (enable) mode.



~~~ruby
R1#write erase
~~~

> Clear the configuration file (i.e. `startup-config`) in NVRAM.



Erasing the nvram filesystem will remove all configuration files! Continue? [confirm]

Press `enter` to confirm deletion.

Erase of nvram: complete



~~~ruby
R1#reload
~~~

Proceed with reload? [confirm]

Press `enter` to confirm device restart.



![2021-09-17_152202](/img/cisco-reset/2021-09-17_152202.png)

At this point, the router has been reset to the default login screen.

---

### Reference:

- [Reset Router to Default Configuration](https://dcloud-cms.cisco.com/help/reset-router)

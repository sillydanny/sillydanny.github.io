---
title: "Cisco - Password Recovery"
date: 2023-06-15T08:48:48+08:00
draft: false
author: "King Tam"
summary: "Cisco - Password Recovery" 
showToc: true
categories:
- Network
tags:
- cisco
- switch
- router
- password recovery
ShowLastMod: true
cover:
    image: "img/cisco-passwd-recovery/cisco-passwd-recovery.jpg"
---

### Introduction:

> All exercises are based on the "Cisco Packet Tracer" software platform.

![Recovery_00](/img/cisco-passwd-recovery/Recovery_00.png)

Connect to the Cisco device through Console.

![Recovery_01](/img/cisco-passwd-recovery/Recovery_01.png)

![Recovery_02](/img/cisco-passwd-recovery/Recovery_02.png)

As the password was forgotten, the Cisco device needs to be restarted manually.

![Recovery_03](/img/cisco-passwd-recovery/Recovery_03.png)

After powering on, press `Ctrl` + `Pause` on the keyboard to interrupt the Router boot process and enter ROM Monitor Mode.

> - Ignore the NVRAM configuration file (Startup-config) in IOS.
> - Change the value of the configuration register from the default `0x2102` to `0x2142`.

![Recovery_04](/img/cisco-passwd-recovery/Recovery_04.png)

~~~ruby
rommon 1 > confreg 0x2142
rommon 2 > reset
~~~

> Use the `reset` command to reload IOS, which will ignore the NVRAM configuration file due to the value of `0x2142`.

> would you like to enter the initial configuration dialog [yes/no]:

Enter `no` and press `enter`.

![Recovery_05.5](/img/cisco-passwd-recovery/Recovery_05.5.png)

~~~ruby
Router>enable
Router#copy startup-config running-config
~~~

> Restore the settings of the Cisco device prior to recovery.

![Recovery_05](/img/cisco-passwd-recovery/Recovery_05.png)

~~~ruby
R1#show running-config
~~~

> View the device settings, mainly to check the privilege and local account information.

![Recovery_06](/img/cisco-passwd-recovery/Recovery_06.png)

There is a privilege (enable) mode password set.

![Recovery_07](/img/cisco-passwd-recovery/Recovery_07.png)

A local account with the username "cisco" and an encrypted password is set.

![Recovery_08](/img/cisco-passwd-recovery/Recovery_08.png)

~~~ruby
R1#configure terminal
R1(config)#enable secret ccna
R1(config)#username cisco secret ccna
R1(config)#exit
~~~

> Reset the privilege mode (enable) password and the local account (cisco) password.

~~~ruby
R1#show version
~~~

Check the device version.

![Recovery_09](/img/cisco-passwd-recovery/Recovery_09.png)

The value of the configuration register is `0x2142`.

![Recovery_10](/img/cisco-passwd-recovery/Recovery_10.png)

~~~ruby
R1#configure terminal
R1(config)#config-register 0x2102
R1(config)#exit
~~~

> Restore the value of the configuration register to `0x2102`.

~~~ruby
R1#show version
~~~

Check the device version again to confirm.

![Recovery_11](/img/cisco-passwd-recovery/Recovery_11.png)

![Recovery_12](/img/cisco-passwd-recovery/Recovery_12.png)

~~~ruby
R1#copy running-config startup-config
~~~

> Write the updated configuration values back to the startup configuration (i.e. save settings).

~~~ruby
R1#reload
~~~

> Restart the device.

![Recovery_13](/img/cisco-passwd-recovery/Recovery_13.png)

The newly set password can be used to log in to the device.

---

### Reference:

- [【CCNA】Cisco Router 忘記密碼 - 密碼復原](https://blog.xuite.net/tolarku/blog/20365059)

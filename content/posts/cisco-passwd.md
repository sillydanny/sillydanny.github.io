---
title: "Cisco - Enable Password Protection"
date: 2023-06-14T16:24:38+08:00
draft: false
author: "King Tam"
summary: "Cisco - Enable Password Protection" 
showToc: true
categories:
- Network
tags:
- cisco
- switch
ShowLastMod: true
cover:
    image: "img/cisco-passwd/cisco-passwd.jpg"
---

# Cisco - Enable Password Protection


### Introduction:

> All of the commands were tested on 'Cisco Packet Tracer'.

---

### Simulating a Console Connection

![2021-09-17_080606](/img/cisco-passwd/2021-09-17_080606.png)

![2021-09-17_080631](/img/cisco-passwd/2021-09-17_080631.png)

---

![2021-09-17_081606](/img/cisco-passwd/2021-09-17_081606.png)

---

### Device Renaming (Option)


~~~ruby
Router>enable
Router#configure terminal
Router(config)#hostname R1
~~~

| Command            | Description                                                  |
| ------------------ | ------------------------------------------------------------ |
| enable             | Enter privilege EXEC mode, which provides access to all the commands in the Cisco IOS software. |
| configure terminal | Enter global configuration mode, which provides access to the configuration commands that affect the entire network device. |
| hostname R1        | Set the hostname of the device to "R1".                      |

---

### Setup Password

~~~ruby
R1(config)#enable secret ccna
~~~

> This command sets the enable secret password to "ccna". The enable secret password is used to control access to privileged EXEC mode.



~~~ruby
R1(config)#line console 0
R1(config-line)#password cisco
R1(config-line)#login	#tell the device use password to connect the console
R1(config-line)#exit
R1(config)#service password-encryption	#encryption the password
R1#exit
~~~

| Command                     | Description                                                  |
| --------------------------- | ------------------------------------------------------------ |
| line console 0              | Configure the settings for the console port.                 |
| password cisco              | Set the password for the console port to "cisco".            |
| login                       | Enable login authentication on the console port.             |
| exit                        | Exit from the current configuration mode.                    |
| service password-encryption | Encrypt all plaintext passwords, including the enable secret password and the console port password. |



~~~ruby
R1(config)#exit
R1#write memory
~~~

| Command      | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| write memory | Save the configuration changes to the device's non-volatile memory. |
| exit         | Exit from the privilege EXEC mode and return to user EXEC mode. |

---

### Verify  Login Via Password

![2021-09-17_085014](/img/cisco-passwd/2021-09-17_085014.png)

User Access Verification

Password: `cisco`

~~~ruby
R1>enable
~~~

Password:`ccna`





---

### Create Local Account

![2021-09-17_085225](/img/cisco-passwd/2021-09-17_085225.png)

Create Console's Account and Password

~~~ruby
R1#enable
R1#configure terminal
R1(config)#username cisco secret ccna
R1(config)#line console 0
R1(config-line)#login local
R1(config-line)#end
R1>logout
~~~

| Command                    | Description                                                  |
| -------------------------- | ------------------------------------------------------------ |
| username cisco secret ccna | Create a user account with the username "cisco" and a secret password of "ccna". |
| line console 0             | Configure the settings for the console port.                 |
| login local                | Enable local authentication for login on the console port.   |
| end                        | Exit from the current configuration mode and return to privileged EXEC mode. |
| logout                     | Logout from the current session and terminate the connection to the device. |



---

### Verify  Local Account Login

![2021-09-17_085516](/img/cisco-passwd/2021-09-17_085516.png)

User Access Verification

Username:`cisco`

Password:`ccna`

~~~ruby
R1>enable
~~~

Password:`ccna`





---

### Remove Password Protection



~~~ruby
R1>enable
R1#configure terminal
(Config)#no enable secret
~~~

| Command          | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| no enable secret | Remove the enable secret password from the device configuration. |



~~~ruby
R1(config)#no username cisco
~~~

| Command           | Description                                                  |
| ----------------- | ------------------------------------------------------------ |
| no username cisco | Remove the user account with the username "cisco" from the device configuration. |

---

**Setup the console port to time out**

~~~ruby
 (config)#line console 0
 (config-line)#exec-time 00 00
 (config-line)#exec-time 02 30
~~~

| Command         | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| line console 0  | Configure the settings for the console port.                 |
| exec-time 00 00 | Set the console port to never time out.                      |
| exec-time 02 30 | Set the console port to time out after 2 hours and 30 minutes of inactivity. |

**Prevents logging messages from interrupting command entry**

~~~ruby
 (config)#line console 0
 (config-line)#logging synchronous
~~~

| Command             | Description                                          |
| ------------------- | ---------------------------------------------------- |
| logging synchronous | Enable synchronous logging mode on the console port. |

---

### Reference:

- [Cisco基本指令-密碼設定](https://david50.pixnet.net/blog/post/45217572-%5b%e7%ad%86%e8%a8%98%5dcisco%e5%9f%ba%e6%9c%ac%e6%8c%87%e4%bb%a4-%e5%af%86%e7%a2%bc%e8%a8%ad%e5%ae%9a)

---
title: "Cisco - Enable SSH Login"
date: 2023-06-14T17:03:27+08:00
draft: false
author: "King Tam"
summary: "Cisco - Enable SSH Login" 
showToc: true
categories:
- Network
tags:
- cisco
- ssh
ShowLastMod: true
cover:
    image: "img/cisco-ssh/cisco-ssh.jpg"
---

# Cisco - Enable SSH login



### Setting the Enable Mode Password


```bash
(Config)#enable secret ccna
```

> To enable login access to the `vty` lines, you must first set the password for the `enable` mode. Otherwise, you will not be able to enter the `enable` mode after logging in.

### Configure a Domain Name

~~~ruby
(config)#ip domain-name ccna.com
~~~

> Using `ip domain-name` to setup domain name `ccna.com`

### Generate an RSA key pair

~~~ruby
(config)#crypto key generate rsa
~~~

How many bit in the modulus[512]:`1024`

>  Using `1024`-bit encryption (default is 512).



### Enable SSH Connection

~~~ruby
(config)#ip ssh version 2
~~~

> Specify the version of SSH is 2

### Create Local Account

~~~ruby
(config)#username cisco privilege 15 secret ccna
~~~

| Command                    | Description                                                  |
| -------------------------- | ------------------------------------------------------------ |
| username cisco secret ccna | Create a user account with the username “cisco” and a secret password of “ccna”. |
| privilege 15               | Set the user account to the highest privilege level (i.e., level 15), which provides full access to all commands on the device. |

### Configure the VTY lines to use SSH

~~~ruby
(config)#line vty 0 4
~~~

> Enabling 0-4 VTY connections (i.e., maximum of 5 simultaneous connections).

### Use the local account for authentication

~~~ruby
(config-line)#login local
~~~

>  Use the local username and password

### Use SSH transport

~~~ruby
(config-line)#transport input ssh
~~~

### Save the configuration

~~~ruby
end
copy running-config startup-config
~~~



---

### Testing SSH Connection

~~~ruby
 #ssh -l cisco 10.255.255.254
~~~

> Test logging in to another Cisco device.
>
> 10.255.255.254 is the IP address of the router.



![image-20210917075953454](/img/cisco-ssh/image-20210917075953454.png)

Or use a Windows SSH terminal.

> After completing these steps, you should be able to SSH into the Cisco device using the configured username and password.

---

### Reference:

- [Cisco基本指令-啟用SSH](https://david50.pixnet.net/blog/post/45217866-%5b%e7%ad%86%e8%a8%98%5dcisco%e5%9f%ba%e6%9c%ac%e6%8c%87%e4%bb%a4-%e5%95%9f%e7%94%a8ssh)



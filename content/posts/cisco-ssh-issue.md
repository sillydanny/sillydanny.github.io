---
title: "Fixing Key Exchange and Cipher Issues on Cisco SG300-10P Switch"
date: 2023-06-30T08:13:31+08:00
draft: false
author: "King Tam"
summary: "Fixing Key Exchange and Cipher Issues on Cisco SG300-10P Switch" 
showToc: true
categories:
- Network
tags:
- cisco
- ssh
ShowLastMod: true
cover:
    image: "img/cisco-ssh-issue/cisco-ssh.jpg"
---


### Problem of SSH

> Here is the "No Matching Key Exchange Method Found" error on your `Cisco SG300-10P` switch.

When attempting to establish an SSH connection with the following command:

```
ssh root@10.1.1.1
```

##### In This Case

| Login Name | Switch IP |
| ---------- | --------- |
| root       | 10.1.1.1  |

An error is encountered due to incompatible key exchange and cipher methods:

> Unable to negotiate with 10.1.1.1 port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1
>
> Unable to negotiate with 10.1.1.1 port 22: no matching cipher found. Their offer: aes128-cbc,3des-cbc,arcfour,aes192-cbc,aes256-cbc

---


### Solution

To resolve the issue, create a new SSH configuration file and restart the SSH service:

1. Run the following command to create a new configuration file, `cisco_sg300.conf`, in the `/etc/ssh/ssh_config.d/` directory:

   ~~~bash
   sudo bash -c 'cat > /etc/ssh/ssh_config.d/cisco_sg300.conf << EOF
   HostkeyAlgorithms ssh-dss,ssh-rsa
   KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group14-sha1
   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
   EOF'
   ~~~

OR minimum algorithms to be compatible with more devices.

~~~bash
sudo cat > /etc/ssh/ssh_config.d/cisco_sg300.conf << EOF
KexAlgorithms +diffie-hellman-group1-sha1,diffie-hellman-group14-sha1
HostKeyAlgorithms +ssh-rsa
Ciphers +aes128-cbc
EOF
~~~

2. Restart the SSH service for the changes to take effect:

   ````bash
   sudo systemctl restart ssh.service
   ````

   ![2023-06-29_203122](/img/cisco-ssh-issue/2023-06-29_203122.png)

---

### Conclusion

> Encountering errors such as "No Matching Key Exchange Method Found" and "No Matching Cipher Found" on your `Cisco SG300-10P` Network Switch can be frustrating, but they can be resolved with a few simple steps.

---
title: "How to Join a Domain with an Existing Computer Account in Server"
date: 2023-06-30T16:48:46+08:00
draft: false
author: "King Tam"
summary: "How to Join a Domain with an Existing Computer Account in Server" 
showToc: true
categories:
- Windows
tags:
- Domain
ShowLastMod: true
cover:
    image: "img/link-domain/link-domain.jpg"
---


## Overview

>  In some situations, such as a system error or hard disk failure, Windows may not boot up properly and require a reinstallation. After reinstalling Windows, you might need to rejoin the computer to the domain.
>
>  This tutorial will guide through the process of re-linking the computer to the existing domain account, which is more convenient than manually deleting the existing computer account from the domain controller server.

---

## Step-by-Step Procedure

1. **Rename the PC according to the asset ID**: Before rejoining the domain, ensure that the computer name matches the asset ID.

![2023-03-20_095232](/img/link-domain/2023-03-20_095232.png)

2. Navigate to `System Properties` > `Computer Name` > `Network ID...`.

![2023-03-20_095241](/img/link-domain/2023-03-20_095241.png)

3. **Choose the network type**: Select the option "`This computer is part of a business network; I use it to connect to other computers at work`" and click `Next`.

![2023-03-20_095246](/img/link-domain/2023-03-20_095246.png)

4. **Select the domain option**: Choose "`My company uses a network with a domain`" and click *`Next`*.

![2023-03-20_095250](/img/link-domain/2023-03-20_095250.png)

5. Click *`Next`* to continue.

![2023-03-20_095254](/img/link-domain/2023-03-20_095254.png)

6. **Provide domain credentials**: Enter the required privileged domain account credentials and click *`Next`*.

![2023-03-20_095312](/img/link-domain/2023-03-20_095312.png)

7. **Re-link the existing computer account**: If the existing computer account is found in the domain, click *`Yes`* to re-link it.

![2023-03-20_095319](/img/link-domain/2023-03-20_095319.png)

8. **Skip domain user account creation**: Select "`Do not add a domain user account`" and click *`Next`*.

![2023-03-20_095329](/img/link-domain/2023-03-20_095329.png)

9. **Finish and reboot**: Click *`Finish`* and restart the computer.

![2023-03-20_095348](/img/link-domain/2023-03-20_095348.png)

10. **Complete the domain rejoining**: After logging in again, the computer will have rejoined the domain.

![2023-03-20_095504](/img/link-domain/2023-03-20_095504.png)

---

## Conclusion

>  By following the steps, you can conveniently rejoin a domain without having to access the domain controller server to delete the existing computer account.
>
>  This method provides an easier way to reconnect your computer to the domain after a system error or hard disk failure.



---
title: "Upgrade Debian from Buster to Bookworm"
date: 2023-07-15T19:24:12+08:00
draft: false
author: "King Tam"
summary: "Upgrade Debian from Buster to Bookworm" 
showToc: true
categories:
- Linux
tags:
- Debian
- Buster
- Bullseye
- Bookworm
ShowLastMod: true
cover:
    image: "img/buster2bookworm/buster2bookworm.jpg"
---

### About

In this scenario, the device has an aarch64 chipset and is running Armbian, which is based on Debian.
It provides a step-by-step guide for upgrading from Debian 10 (Buster) to Debian 11 (Bullseye), and then to Debian 12 (Bookworm).

---

### Upgrade from Buster to Bullseye

1. **Backup data.** 
This should always be the first step before making major system changes. You can use tools like `rsync` or `tar` to backup the data.

2. **Verify Current Debian Version**

~~~bash
lsb_release -a
~~~

![2023-07-14_081241](/img/buster2bookworm/2023-07-14_081241.png)

3. **Update the current system.** 
Ensure  the current system is fully up-to-date by running:

~~~bash
sudo apt update  && sudo apt upgrade -y
sudo apt full-upgrade
~~~

4. **Change the repositories.** 

Create a backup of current `sources.list` file by renaming it to `sources.lists.bak`	

~~~bash
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
~~~~

Create a new one with the following contents:

~~~bash
sudo cat >> /etc/apt/sources.list << EOF
deb [arch=arm64,armhf] http://deb.debian.org/debian bullseye main contrib non-free
deb [arch=arm64,armhf] http://deb.debian.org/debian bullseye-updates main contrib non-free
deb [arch=arm64,armhf] http://deb.debian.org/debian bullseye-backports main contrib non-free
deb [arch=arm64,armhf] http://security.debian.org/ bullseye-security/updates main contrib non-free
EOF
~~~

Edit `/etc/apt/sources.list.d/*` files to point to Bullseye instead of Buster.

~~~bash
sudo sed -i 's/buster/bullseye/g' /etc/apt/sources.list.d/*.list
~~~

5. **Update the package list.** 
Run the following command to update the package list:

~~~bash
sudo apt update
~~~

> Hit:1 http://deb.debian.org/debian bullseye InRelease
> Hit:2 http://deb.debian.org/debian bullseye-updates InRelease
> Hit:3 http://deb.debian.org/debian bullseye-backports InRelease
> Hit:4 http://security.debian.org bullseye-security/updates InRelease
> Get:5 http://mirrors.sustech.edu.cn/armbian bullseye InRelease [53.3 kB]
> Fetched 53.3 kB in 2s (24.6 kB/s)
> Reading package lists... Done
> Building dependency tree
> Reading state information... Done
> 397 packages can be upgraded. Run 'apt list --upgradable' to see them.

6. **Perform a minimal system upgrade:** 
   Upgrade all existing packages without installing or removing any additional packages with this command:

~~~bash
sudo apt upgrade --without-new-pkgs
~~~

After this operation, several questions will be asked to confirm. Keep pressing the `Enter` key to continue. Below are some examples:

>  The default action is to keep your current version.
> *** issue.net (Y/I/N/O/D/Z) [default=N] ?

7. **Upgrade the packages.** 
   Now you can upgrade all system's packages to Bullseye versions with:

~~~bash
sudo apt full-upgrade -y
~~~

8. **Restart the system.** 
After the upgrade is complete, you should restart the system to ensure all changes are properly applied.

~~~bash
sudo reboot
~~~

9. **Check the Debian version.** 
Once the system reboots, check the Debian version to confirm the upgrade:

~~~bash
lsb_release -a
~~~
![2023-07-14_092619](/img/buster2bookworm/2023-07-14_092619.png)

Congratulations on successfully upgrading to Debian 11 (Bullseye)!

10. **Clean unused packages:** 
Ensure a clean system by removing any packages that are no longer required.

~~~bash
sudo apt --purge autoremove -y
sudo find /etc -name '.dpkg-' -o -name '.ucf-' -o -name '*.merge-error'
~~~


---

### Upgrade from Bullseye to Bookworm

Follow the same steps as above

1. **Update current system.** 
Ensure  current system is fully up-to-date by running:

~~~bash
sudo apt update  && sudo apt upgrade -y
sudo apt full-upgrade -y
~~~

2. **Change the repositories.** 

Replace 'bullseye' with 'bookworm' in `/etc/apt/sources.list` and `/etc/apt/sources.list.d/*` files via sed.

~~~bash
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list
sudo sed -i 's/bullseye/bookworm/g' /etc/apt/sources.list.d/armbian.list
~~~

Additionally, add the "non-free-firmware" repository for hardware driver support.

~~~bash
sudo sed -i 's/non-free/non-free non-free-firmware/g' /etc/apt/sources.list
sudo sed -i 's/non-free/non-free non-free-firmware/g' /etc/apt/sources.list.d/*
~~~


3. **Update the package list.** 
Run the following command to update the package list:

~~~bash
sudo apt update
~~~

4. **Perform a minimal system upgrade:** 
Upgrade all existing packages without installing or removing any additional packages with this command:

~~~bash
sudo apt upgrade --without-new-pkgs
~~~

After this operation, several questions will be asked to confirm. Keep pressing the `Enter` key to continue. Below are some examples:

>  The default action is to keep your current version.
> *** issue.net (Y/I/N/O/D/Z) [default=N] ?

5. **Upgrade the packages.** 
    Now you can upgrade all system's packages to Bookworm versions with:

~~~bash
sudo apt full-upgrade -y
~~~

6. **Restart the system.** 
After the upgrade is complete, you should restart the system to ensure all changes are properly applied.

~~~bash
sudo reboot
~~~

7. **Check the Debian version.** 
Once the system reboots, check the Debian version to confirm the upgrade:

~~~bash
lsb_release -a
~~~
![2023-07-14_101328](/img/buster2bookworm/2023-07-14_101328.png)


Congratulations on successfully to Debian 12 (bookworm)!



8. **Clean unused packages:** 
Ensure a clean system by removing any packages that are no longer required.

~~~bash
sudo apt --purge autoremove -y
sudo find /etc -name '.dpkg-' -o -name '.ucf-' -o -name '*.merge-error'
~~~

---

### Resolving the Warning of Key Stored Issue on `apt update`

#### <u>Issue:</u>

When running `apt update`, a warning message may appear indicating that a key stored in `/etc/apt/trusted.gpg` is no longer valid.

#### <u>Solution:</u>

To resolve the issue, follow these steps:

1. List the available keys with the following command:

~~~bash
sudo apt-key list
~~~

   > Take note of the last 8 digits of the public key that corresponds to the repository being updated.

2. Export the public key to a new file using the following command:

~~~bash
sudo apt-key export <last-8-digits-of-public-key> | gpg --dearmour -o /etc/apt/trusted.gpg.d/armbian.gpg
~~~

   This will create a new trusted key file named `armbian.gpg` in the `/etc/apt/trusted.gpg.d/` directory.

3. Update the package lists to confirm that the key issue has been resolved:

~~~bash
sudo apt update
~~~


---



### Conclusion

Upgrading from Debian 10 (Buster) to Debian 12 (Bookworm) provides a range of benefits such as new features and improvements, regular security updates, long-term support, and compatibility with newer software and hardware. 


---

### Reference

- [Upgrade from Debian 10 (Buster) To Debian 11 (Bullseye)](https://computingforgeeks.com/upgrade-from-debian-10-buster-to-debian-11-bullseye/?expand_article=1)

- [How To Upgrade To Debian 12 Bookworm From Debian 11 Bullseye](https://ostechnix.com/upgrade-to-debian-12-from-debian-11/)



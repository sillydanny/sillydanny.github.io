---
title: "Installing CUPS on PVE's LXC Container System"
date: 2023-05-29T14:55:24+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Linux
- PVE
tags:
- cups
- lxc
ShowLastMod: true
cover:
    image: "img/pve-lxc-cups/pve-lxc-cups.png"
---

# Installing CUPS on PVE's LXC Container System


<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Introduction:</b></font></td></tr></table>

> At home, I use a `Canon LBP6030` **USB** printer connected to a [Padavan system on a router (Youku1) to enable wireless printing](https://kingtam.win/archives/PrinterServer.html). However, wireless printing can only be achieved on the **Windows** platform, and on systems such as **macOS** and **IOS** from **Apple**, it cannot be achieved, causing some inconvenience.
>
> I came across this post on `SMZDM` [N1刷armbian變身打印服務器](https://post.smzdm.com/p/alpz07r0/), which can install `CUPS` software as a printer server system, and thus the following content was recorded.


<span id="toc"></span>

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Table of Contents:</b></font></td></tr></table>

- [Requirements](#qualification)
- [Installation of LXC container system (Debian) on PVE](#lxc)
- [Passing through USB ports to LXC](#usb)
- [Installation of CUPS software and printer driver on LXC (Debian)](#cups)
- [Installation and printing test on multiple platform systems](#client)
  - [Installing the printer on Windows 10](#win10)
  - [Installing the printer on Windows 7](#win7)
  - [Installing the printer on macOS](#macos)
  - [Installing the printer on Android](#android)
  - [Installing the printer on Linux (Deepin)](#Linux)


<span id="qualification"></span>

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Requirements:</b></font></td></tr></table>

- Platform that can install `CUPS` software

  > Such as **armbian**, **ubuntu**, **centos**, etc. I chose the **Debian** **Linux** platform.

- Printer driver that supports the platform

  > If the driver that supports the platform can be found on [OpenPrinting](https://www.openprinting.org/printers), this step can be ignored.


<span id="lxc"></span>

[Return to Table of Contents](#toc)

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Installation of LXC container system (Debian) on PVE</b></font></td></tr></table>

> `LXC` provides an operating system-level virtualization environment that is installed on a system based on `Linux`.
>
> The free `PVE` virtual server makes it easy to create a new `Linux` system (i.e., a canned system) with a shared kernel.

Download the `CT` template:

![](/img/pve-lxc-cups/2021-08-01_180807.png)

![](/img/pve-lxc-cups/2021-08-01_180852.png)

Create the `LXC` system:


![](/img/pve-lxc-cups/2021-08-01_180903.png)

![](/img/pve-lxc-cups/2021-08-01_180951.png)

![](/img/pve-lxc-cups/2021-08-01_181002.png)

![](/img/pve-lxc-cups/2021-08-01_181008.png)

![](/img/pve-lxc-cups/2021-08-01_181014.png)

![](/img/pve-lxc-cups/2021-08-01_181016.png)

![](/img/pve-lxc-cups/2021-08-01_181030.png)

![](/img/pve-lxc-cups/2021-08-01_181037.png)

![](/img/pve-lxc-cups/2021-08-01_181102.png)

The newly created LXC system does not need to be started yet.


<span id="usb"></span>

[Return to Table of Contents](#toc)

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Passing through USB ports to LXC:</b></font></td></tr></table>

> Connect the **USB** port of the printer `Canon LBP6030` to the **USB** port of the `PVE` host.

![](/img/pve-lxc-cups/2021-08-01_181144.png)

Use `lsusb` to check the connected **USB** devices:

~~~ruby
lsusb
~~~

We can see that `Device 003` on `Bus 001` is `Canon`.


![](/img/pve-lxc-cups/2021-08-01_181251.png)

Check thedevice number of `Canon` on the `Bus 001`:

~~~ruby
ls -al /dev/bus/usb/001
~~~

> Allow LXC to access the USB device on PVE through `cgroup`.

~~~ruby
cat >> '/etc/pve/lxc/100.conf' << EOF
lxc.cgroup2.devices.allow: c 189:* rwm
lxc.mount.entry: /dev/bus/usb/001 dev/bus/usb/001 none bind,optional,create=dir
EOF
~~~

> The `ID` of `LXC` is `100`, and the configuration file path is `/etc/pve/lxc/100.conf`.
>
> The device inside `189:* rwm` is allowed to be read, written, and mounted.
>
> Mount the entire `Bus 001` **USB** port. The advantage of this is that even if the device number changes due to unplugging the USB port of the printer multiple times, the mounting will not be affected.

![](/img/pve-lxc-cups/2021-07-29_195234.png)

Start the newly created `LXC` container.


![](/img/pve-lxc-cups/2021-08-01_181325.png)


Check if it has been mounted in the `LXC` container's `Console`:

~~~ruby
dmesg | grep -in 'canon'
1617:[3489934.461195] usb 1-1: Manufacturer: Canon,Inc.
1837:[3494585.821378] usb 1-1: Manufacturer: Canon,Inc.
~~~


> Seeing `Manufacturer: Canon, Inc.` means that the **USB** printer has successfully connected to the `LXC` container.

<span id="cups"></span>

[Return to Table of Contents](#toc)

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Installation of CUPS software and printer driver on LXC (Debian)</b></font></td></tr></table>

> `CUPS` (Common UNIX Printing System) is a printing system supported in Fedora Core3 that mainly uses `IPP` (Internet Printing Protocol) to manage print jobs and queues, but also supports communication protocols such as `LPD` (Line Printer Daemon), `SMB` (Server Message Block), and `AppSocket`. [From Baidu](https://baike.baidu.com/item/CUPS/13007261)

Install the `CUPS` software:

~~~ruby
sudo apt update && sudo apt install -y cups
~~~

Enable remote access to `CUPS`:

~~~ruby
sudo cupsctl --remote-any
~~~

Add the current user to the `lpadmin` group:

~~~ruby
sudo usermod -aG lpadmin $USER
~~~

If the printer that is supported can be found on [OpenPrinting](https://www.openprinting.org/printers), this step can be ignored.

Download and install the printer driver for `Canon LBP6030`:

~~~ruby
wget https://gdlp01.c-wss.com/gds/0/0100005950/10/linux-UFRIILT-drv-v500-uken-18.tar.gz \
&& tar xzvf linux-UFRIILT-drv-v500-uken-18.tar.gz \
&& sudo dpkg -i ./linux-UFRIILT-drv-v500-uken/64-bit_Driver/Debian/cnrdrvcups-ufr2lt-uk_5.00-1_amd64.deb \
&& rm -rf linux-UFRIILT-drv-v500-uken linux-UFRIILT-drv-v500-uken-18.tar.gz
~~~

Enter the following address in a browser: https://10.1.1.253:631/admin/

> The IP address of the `LXC` system is: `10.1.1.253`

![](/img/pve-lxc-cups/2021-08-02_084618.png)

![](/img/pve-lxc-cups/2021-08-02_084627.png)

![](/img/pve-lxc-cups/2021-08-02_084631.png)

![](/img/pve-lxc-cups/2021-08-02_084648.png)

![](/img/pve-lxc-cups/2021-08-02_084707.png)

![](/img/pve-lxc-cups/2021-08-02_084727.png)

![](/img/pve-lxc-cups/2021-08-02_084744.png)

![](/img/pve-lxc-cups/2021-08-01_180521.png)

Print test page:

![](/img/pve-lxc-cups/TestPage.png)

> Installing `CUPS` software completes the configuration of the printer server system.

<span id="client"></span>

[Return to Table of Contents](#toc)

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Installation and testing of printer on multiple platforms</b></font></td></tr></table>

> After the deployment of `CUPS` software, multiple platforms can share printers. In the following example, I tested wireless printing functionality on `Windows7`, `Windows10`, `macOS`, `iOS`, and `Android`.

<span id="win10"></span>

<table><tr><td bgcolor=#1E78FF><font color=white><b>Installing Printer on Windows 10:</b></font></td></tr></table>

#### <u>**Installing Printer through Search**</u>

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_01.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_02.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_03.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_04.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_05.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_06.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_07.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_07-30_08.png)

#### **<u>Manual Installation of Printer</u>**

> If the printer cannot be found through search or on a different network segment, manual installation of the printer is required.

![](/img/pve-lxc-cups/CUPS_WIN10_08-02_01.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_08-02_02.PNG)

Open the `CUPS` interface by entering `http://10.1.1.253:631` in a browser and copy the path.

![](/img/pve-lxc-cups/CUPS_WIN10_08-02_03.PNG)

Paste the path # Note that it cannot be `https`.

![](/img/pve-lxc-cups/CUPS_WIN10_08-02_04.PNG)

![](/img/pve-lxc-cups/CUPS_WIN10_08-02_05.png)


<span id="win7"></span>

[Return to Table of Contents](#toc)

<table><tr><td bgcolor=#1E78FF><font color=white><b>Installing Printer on Windows 7:</b></font></td></tr></table>

> Manually install the printer and prepare the corresponding Windows driver in advance.

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_01.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_02.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_03.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_04.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_05.PNG)

Note that the pasted path cannot be `https`.

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_06.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_07.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_08.PNG)

Select the Windows driver that was prepared in advance.

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_09.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_10.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_11.PNG)

![](/img/pve-lxc-cups/CUPS_WIN7_07-30_12.png)

<span id="macos"></span>

[Return to Table of Contents](#toc)

<table><tr><td bgcolor=#1E78FF><font color=white><b>Installing Printer on macOS:</b></font></td></tr></table>

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-31_9.00.59.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-30_6.36.37.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-30_6.36.44.png)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-30_6.37.00.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-30_6.37.08.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-31_8.57.49.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-31_8.58.02.PNG)

![](/img/pve-lxc-cups/CUPS_MACOS_2021-07-31_8.59.44.PNG)

<span id="android"></span>

[Return to Table of Contents](#toc)

<table><tr><td bgcolor=#1E78FF><font color=white><b>Installing Printer on Android:</b></font></td></tr></table>

> The tested Android device is the OnePlus 6, and the "Mopria Print Service" app is installed from the software store.

![](/img/pve-lxc-cups/CUPS_ANDROID__01.JPG)

![](/img/pve-lxc-cups/CUPS_ANDROID__02.JPG)

![](/img/pve-lxc-cups/CUPS_ANDROID__03.JPG)

![](/img/pve-lxc-cups/CUPS_ANDROID__04.JPG)

![](/img/pve-lxc-cups/CUPS_ANDROID__05.PNG)


<span id="Linux"></span>

[Return to Table of Contents](#toc)

<table><tr><td bgcolor=#1E78FF><font color=white><b>Installing Printer on Linux (Deepin):</b></font></td></tr></table>

![](/img/pve-lxc-cups/CPUS_Linux_01.jpg)

![](/img/pve-lxc-cups/CPUS_Linux_02.jpg)

![](/img/pve-lxc-cups/CPUS_Linux_03.png)

![](/img/pve-lxc-cups/CPUS_Linux_04.png)

![](/img/pve-lxc-cups/CPUS_Linux_05.jpg)

[Return to Table of Contents](#toc)

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>Conclusion:</b></font></td></tr></table>

> I believe that the most difficult part is the installation of the printer driver. If the manufacturer and model are found on OpenPrinting, the process should be relatively simple.


> The advantage of using PVE's LXCcontainer with CUPS installed is that it makes managing printers on a network much easier, especially for multiple users and devices. Overall, the installation process for printers on different operating systems varies, but with the right steps and information, it can be accomplished successfully.


> Manually install printers using software like `zero-tier`, which can enable remote (cross-regional) printing. For example, you can directly access your home printer from work to print documents.

---

###

<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=5 color=white><b>References:</b></font></td></tr></table>

[USB Passthrough to an LXC (Proxmox)](https://medium.com/@konpat/usb-passthrough-to-an-lxc-proxmox-15482674f11d)

[OpenPrinting](https://www.openprinting.org/printers)

[N1刷armbian變身列印伺服器，支援全平臺無線列印@PC掃描](https://post.smzdm.com/p/alpz07r0/)

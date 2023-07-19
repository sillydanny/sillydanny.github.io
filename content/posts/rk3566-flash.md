---
title: "Universal Flashing Guide for Rockchip Devices"
date: 2023-06-27T17:05:06+08:00
draft: false
author: "King Tam"
summary: "Universal Flashing Guide for Rockchip Devices" 
showToc: true
categories:
- 
tags:
- armbian
- Rockchip
- RK3566
- Panther X2
ShowLastMod: true
cover:
    image: "img/rk3566-flash/rk3566-flash.jpg"
---



### Introduction

This is a universal flashing guide for `Rockchip` devices. Simply match the `boot` (system bootloader file) and `system` (system image file), and you can easily flash the specified system, such as `Armbian`, `OpenWRT`, `AndroidTV` etc.

---

### Prerequisites

Hardware:

- Rockchip device (e.g., Panther X2, L1-Pro)
- USB cable (dual-headed USB-A)
- Computer (Windows (recommended), macOS, Linux)

Software:

- DriverAssitant (Rockchip driver)
- RKDevTool (Rockchip flashing tool)
- BootLoader (system bootloader file)
- System (system image file)

---

### Flashing Procedure

This guide uses Panther X2 as an example:

1. Install the Rockchip driver.

Download File : [DriverAssitant_v5.1.1.zip](https://download.t-firefly.com/product/Board/RK356X/Tool/Window/DriverAssitant/DriverAssitant_v5.1.1.zip)


![2023-06-27_050728](/img/rk3566-flash/2023-06-27_050728.png)

![2023-06-27_050742](/img/rk3566-flash/2023-06-27_050742.png)

![2023-06-27_050752](/img/rk3566-flash/2023-06-27_050752.png)

2. Run the flashing tool.

![panther_x_hotspot_helium](/img/rk3566-flash/panther_x_hotspot_helium.jpg)

Download File : [RKDevTool_Release_v2.84.zip](https://download.t-firefly.com/product/Board/RK356X/Tool/Window/AndroidTool/RKDevTool_Release_v2.84.zip)


![2023-06-24_190159](/img/rk3566-flash/2023-06-24_190159.png)

When the **LOADER** device is detected, go to the "**Advanced Function**" tab and enable "Maskrom" mode.

> Note: MaskROM is a special type of read-only memory (ROM) made by Rockchip. It is used as an emergency boot mode for repairing or upgrading Rockchip's system chips.

![2023-06-24_190512](/img/rk3566-flash/2023-06-24_190512.png)

Return to the "**Download Image**" tab.

- The boot (system bootloader file) is the `rk356x-MiniLoaderAll.bin` in the flashing tool.
- The system (system image file) is [Armbian_23.08.0_rockchip_panther-x2_bookworm_6.1.35_server_2023.06.21.img.gz](https://github.com/ophub/amlogic-s9xxx-armbian/releases/download/Armbian_bookworm_save_2023.06/Armbian_23.08.0_rockchip_panther-x2_bookworm_6.1.35_server_2023.06.21.img.gz). Download and unzip it to a local directory.

Click the "Run" button and wait for `Download image OK`.

Power off and restart to enter the system.

---



### Armbian System Default Information

| Name             | Value                 |
| ---------------- | --------------------- |
| Default IP       | Obtain IP from router |
| Default account  | root                  |
| Default password | 1234                  |

 ![2023-06-25_182738](/img/rk3566-flash/2023-06-25_182738.png)

| Steps | Description                                      |
| ----- | ------------------------------------------------ |
| 1     | Set up root password (needs to be entered twice) |
| 2     | Select `1) bash`                                 |
| 3     | `<Ctrl-C>` to cancel creating a new account      |

![2023-06-27_135955](/img/rk3566-flash/2023-06-27_135955.png)

![2023-06-27_140122](/img/rk3566-flash/2023-06-27_140122.png)

---

### Fixing the Panther X2 USB Unrecognized Issue

Execute as root user:

~~~bash
sudo -i
~~~

> The system will prompt for a password.

Run the following commands:

~~~bash
cd /boot/dtb/rockchip
dtc -I dtb -O dts rk3566-panther-x2.dtb > rk3566-panther-x2.dts
sed -i '/usb@fcc00000/{:a;n;/.*dr_mode = "otg";/!ba;s/dr_mode = "otg"/dr_mode = "host"/}' rk3566-panther-x2.dts
dtc -I dts -O dtb rk3566-panther-x2.dts > rk3566-panther-x2.dtb
~~~

![2023-06-27_140859](/img/rk3566-flash/2023-06-27_140859.png)

> This command changes the `otg` to `host` within the `usb@fcc00000` block, meaning it changes the USB mode from OTG to Host mode. The USB device will act as a host, controlling data read and write operations with external devices.

Once the commands are executed, reboot the device for the changes to take effect:

~~~bash
reboot
~~~

After the reboot, the USB issues should be resolved, and the USB ports should function as expected in host mode.

![2023-06-27_141139](/img/rk3566-flash/2023-06-27_141139.png)

---

### Conclusion

This guide is for informational purposes only and is intended to make it easier for users to find and save the relevant information. 

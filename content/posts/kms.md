---
title: "Windows and Office Activation Guide (KMS)"
date: 2023-06-30T16:22:32+08:00
draft: false
author: "King Tam"
summary: "Windows and Office Activation Guide (KMS)" 
showToc: true
categories:
- Windows 
tags:
- KMS
- Office
- Docker
ShowLastMod: true
cover:
    image: "img/kms/kms.jpg"
---


[Pic From](https://unsplash.com/s/photos/windows-11)

<table><tr align="left"><td bgcolor=fe3748><font color=white><b>Attention:</b> </font></td></tr></table>

> `Ensure you are purchasing sufficient licenses to take this action.`

### Instructions ###

- KMS activation has a 180-day period, which is called the activation validity interval
- To maintain activation, your system must renew activation by connecting to the KMS server at least once every 180 days
- By default, activation renewal attempts are automatically made every 7 days
- After you renew client activation, the activation interval restarts
- As long as you can't connect to the internet for more than 180 days, the system will self-renew and remain active

---

### Installation ###

One-click installation of KMS service scripts

```bash
wget --no-check-certificate https://raw.githubusercontent.com/teddysun/across/master/kms.sh && chmod +x kms.sh && ./kms.sh

netstat -nxtlp | grep 1688 # Check the port 1688
/etc/init.d/kms status # Service Status
/etc/init.d/kms start # Start Service
/etc/init.d/kms stop # Stop Service
/etc/init.d/kms restart # Restart Service
./kms.sh uninstall # Uninstall
```

Docker installation (docker-compose)

```yaml
version: '3'
services:
	kms:
		image: teddysun/kms
		container_name: kms
		ports:
			- "1688:1688"
		restart: always
```

---

### How to use KMS activation ###

Run CMD with administrator privileges to view the system version:

```bash
wmic os get caption
```

Install the key from the correct version

```bash
slmgr /ipk xxxxx-xxxxx-xxxxx-xxxxx-xxxxx
```

The Key reference [GVLK](#key)

Set the KMS server address

~~~bash
slmgr /skms Your IP or Domain:1688
~~~

> e.g. `slmgr /skms 10.2.2.10:1688`

| Server: | URL (address):    |
| ------- | ----------------- |
| 01      | skms.netnr.eu.org |
| 02      | kms.cangshui.net  |
| 03      | kms.03k.org       |

Activate the system

~~~bash
slmgr /ato
~~~

Query expiration time

~~~bash
slmgr /xpr
~~~



---



<span id="key"></span>

## Generic Volume License Keys (GVLK)

In the tables that follow, you will find the GVLKs for each version and edition of Windows. LTSC is *Long-Term Servicing Channel*, while LTSB is *Long-Term Servicing Branch*.

### Windows Server (LTSC versions)

#### Windows Server 2022

| Operating system edition       | KMS Client Product Key        |
| ------------------------------ | ----------------------------- |
| Windows Server 2022 Datacenter | WX4NM-KYWYW-QJJR4-XV3QB-6VM33 |
| Windows Server 2022 Standard   | VDYBN-27WPP-V4HQT-9VMD4-VMK7H |

#### Windows Server 2019

| Operating system edition       | KMS Client Product Key        |
| ------------------------------ | ----------------------------- |
| Windows Server 2019 Datacenter | WMDGN-G9PQG-XVVXX-R3X43-63DFG |
| Windows Server 2019 Standard   | N69G4-B89J2-4G8F4-WWYCC-J464C |
| Windows Server 2019 Essentials | WVDHN-86M7X-466P6-VHXV7-YY726 |

#### Windows Server 2016

| Operating system edition       | KMS Client Product Key        |
| ------------------------------ | ----------------------------- |
| Windows Server 2016 Datacenter | CB7KF-BWN84-R7R2Y-793K2-8XDDG |
| Windows Server 2016 Standard   | WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY |
| Windows Server 2016 Essentials | JCKRF-N37P4-C2D82-9YXRT-4M63B |

### Windows Server (Semi-Annual Channel versions)

#### Windows Server, versions 20H2, 2004, 1909, 1903, and 1809

| Operating system edition  | KMS Client Product Key        |
| ------------------------- | ----------------------------- |
| Windows Server Datacenter | 6NMRW-2C8FM-D24W7-TQWMY-CWH2D |
| Windows Server Standard   | N2KJX-J94YW-TQVFB-DG9YT-724CC |

### Windows 11 and Windows 10 (Semi-Annual Channel versions)

See the [Windows lifecycle fact sheet](https://support.microsoft.com/help/13853/windows-lifecycle-fact-sheet) for information about supported versions and end of service dates.

| Operating system edition                                     | KMS Client Product Key        |
| ------------------------------------------------------------ | ----------------------------- |
| Windows 11 Pro Windows 10 Pro                                | W269N-WFGWX-YVC9B-4J6C9-T83GX |
| Windows 11 Pro N Windows 10 Pro N                            | MH37W-N47XK-V7XM9-C7227-GCQG9 |
| Windows 11 Pro for Workstations Windows 10 Pro for Workstations | NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J |
| Windows 11 Pro for Workstations N Windows 10 Pro for Workstations N | 9FNHH-K3HBT-3W4TD-6383H-6XYWF |
| Windows 11 Pro Education Windows 10 Pro Education            | 6TP4R-GNPTD-KYYHQ-7B7DP-J447Y |
| Windows 11 Pro Education N Windows 10 Pro Education N        | YVWGF-BXNMC-HTQYQ-CPQ99-66QFC |
| Windows 11 Education Windows 10 Education                    | NW6C2-QMPVW-D7KKK-3GKT6-VCFB2 |
| Windows 11 Education N Windows 10 Education N                | 2WH4N-8QGBV-H22JP-CT43Q-MDWWJ |
| Windows 11 Enterprise Windows 10 Enterprise                  | NPPR9-FWDCX-D2C8J-H872K-2YT43 |
| Windows 11 Enterprise N Windows 10 Enterprise N              | DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4 |
| Windows 11 Enterprise G Windows 10 Enterprise G              | YYVX9-NTFWV-6MDM3-9PT4T-4M68B |
| Windows 11 Enterprise G N Windows 10 Enterprise G N          | 44RPN-FTY23-9VTTB-MP9BX-T84FV |

### Windows 10 (LTSC/LTSB versions)

#### Windows 10 LTSC 2021 and 2019

| Operating system edition                                     | KMS Client Product Key        |
| ------------------------------------------------------------ | ----------------------------- |
| Windows 10 Enterprise LTSC 2021 Windows 10 Enterprise LTSC 2019 | M7XTQ-FN8P6-TTKYV-9D4CC-J462D |
| Windows 10 Enterprise N LTSC 2021 Windows 10 Enterprise N LTSC 2019 | 92NFX-8DJQP-P6BBQ-THF9C-7CG2H |

#### Windows 10 LTSB 2016

| Operating system edition          | KMS Client Product Key        |
| --------------------------------- | ----------------------------- |
| Windows 10 Enterprise LTSB 2016   | DCPHK-NFMTC-H88MJ-PFHPY-QJ4BJ |
| Windows 10 Enterprise N LTSB 2016 | QFFDN-GRT3P-VKWWX-X7T3R-8B639 |

#### Windows 10 LTSB 2015

| Operating system edition          | KMS Client Product Key        |
| --------------------------------- | ----------------------------- |
| Windows 10 Enterprise 2015 LTSB   | WNMTR-4C88C-JK8YV-HQ7T2-76DF9 |
| Windows 10 Enterprise 2015 LTSB N | 2F77B-TNFGY-69QQF-B8YKP-D69TJ |

### Earlier versions of Windows Server

#### Windows Server, version 1803

| Operating system edition  | KMS Client Product Key        |
| ------------------------- | ----------------------------- |
| Windows Server Datacenter | 2HXDN-KRXHB-GPYC7-YCKFJ-7FVDG |
| Windows Server Standard   | PTXN8-JFHJM-4WC78-MPCBR-9W4KR |

#### Windows Server, version 1709

| Operating system edition  | KMS Client Product Key        |
| ------------------------- | ----------------------------- |
| Windows Server Datacenter | 6Y6KB-N82V8-D8CQV-23MJW-BWTG6 |
| Windows Server Standard   | DPCNP-XQFKJ-BJF7R-FRC8D-GF6G4 |

#### Windows Server 2012 R2

| Operating system edition          | KMS Client Product Key        |
| --------------------------------- | ----------------------------- |
| Windows Server 2012 R2 Standard   | D2N9P-3P6X9-2R39C-7RTCD-MDVJX |
| Windows Server 2012 R2 Datacenter | W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9 |
| Windows Server 2012 R2 Essentials | KNC87-3J2TX-XB4WP-VCPJV-M4FWM |

#### Windows Server 2012

| Operating system edition                | KMS Client Product Key        |
| --------------------------------------- | ----------------------------- |
| Windows Server 2012                     | BN3D2-R7TKB-3YPBD-8DRP2-27GG4 |
| Windows Server 2012 N                   | 8N2M2-HWPGY-7PGT9-HGDD8-GVGGY |
| Windows Server 2012 Single Language     | 2WN2H-YGCQR-KFX6K-CD6TF-84YXQ |
| Windows Server 2012 Country Specific    | 4K36P-JN4VD-GDC6V-KDT89-DYFKP |
| Windows Server 2012 Standard            | XC9B7-NBPP2-83J2H-RHMBY-92BT4 |
| Windows Server 2012 MultiPoint Standard | HM7DN-YVMH3-46JC3-XYTG7-CYQJJ |
| Windows Server 2012 MultiPoint Premium  | XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G |
| Windows Server 2012 Datacenter          | 48HP8-DN98B-MYWDG-T2DCC-8W83P |

#### Windows Server 2008 R2

| Operating system edition                         | KMS Client Product Key        |
| ------------------------------------------------ | ----------------------------- |
| Windows Server 2008 R2 Web                       | 6TPJF-RBVHG-WBW2R-86QPH-6RTM4 |
| Windows Server 2008 R2 HPC edition               | TT8MH-CG224-D3D7Q-498W2-9QCTX |
| Windows Server 2008 R2 Standard                  | YC6KT-GKW9T-YTKYR-T4X34-R7VHC |
| Windows Server 2008 R2 Enterprise                | 489J6-VHDMP-X63PK-3K798-CPX3Y |
| Windows Server 2008 R2 Datacenter                | 74YFP-3QFB3-KQT8W-PMXWJ-7M648 |
| Windows Server 2008 R2 for Itanium-based Systems | GT63C-RJFQ3-4GMB6-BRFB9-CB83V |

#### Windows Server 2008

| Operating system edition                       | KMS Client Product Key        |
| ---------------------------------------------- | ----------------------------- |
| Windows Web Server 2008                        | WYR28-R7TFJ-3X2YQ-YCY4H-M249D |
| Windows Server 2008 Standard                   | TM24T-X9RMF-VWXK6-X8JC9-BFGM2 |
| Windows Server 2008 Standard without Hyper-V   | W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ |
| Windows Server 2008 Enterprise                 | YQGMW-MPWTJ-34KDK-48M3W-X4Q6V |
| Windows Server 2008 Enterprise without Hyper-V | 39BXF-X8Q23-P2WWT-38T2F-G3FPG |
| Windows Server 2008 HPC                        | RCTX3-KWVHP-BR6TB-RB6DM-6X7HP |
| Windows Server 2008 Datacenter                 | 7M67G-PC374-GR742-YH8V4-TCBY3 |
| Windows Server 2008 Datacenter without Hyper-V | 22XQ2-VRXRG-P8D42-K34TD-G3QQC |
| Windows Server 2008 for Itanium-Based Systems  | 4DWFP-JF3DJ-B7DTH-78FJB-PDRHK |

### Earlier versions of Windows

#### Windows 8.1

| Operating system edition | KMS Client Product Key        |
| ------------------------ | ----------------------------- |
| Windows 8.1 Pro          | GCRJD-8NW9H-F2CDX-CCM8D-9D6T9 |
| Windows 8.1 Pro N        | HMCNV-VVBFX-7HMBH-CTY9B-B4FXY |
| Windows 8.1 Enterprise   | MHF9N-XY6XB-WVXMC-BTDCT-MKKG7 |
| Windows 8.1 Enterprise N | TT4HM-HN7YT-62K67-RGRQJ-JFFXW |

#### Windows 8

| Operating system edition | KMS Client Product Key        |
| ------------------------ | ----------------------------- |
| Windows 8 Pro            | NG4HW-VH26C-733KW-K6F98-J8CK4 |
| Windows 8 Pro N          | XCVCF-2NXM9-723PB-MHCB7-2RYQQ |
| Windows 8 Enterprise     | 32JNW-9KQ84-P47T8-D8GGY-CWCK7 |
| Windows 8 Enterprise N   | JMNMF-RHW7P-DMY6X-RF3DR-X2BQT |

#### Windows 7

| Operating system edition | KMS Client Product Key        |
| ------------------------ | ----------------------------- |
| Windows 7 Professional   | FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4 |
| Windows 7 Professional N | MRPKT-YTG23-K7D7T-X2JMM-QY7MG |
| Windows 7 Professional E | W82YF-2Q76Y-63HXB-FGJG9-GF7QX |
| Windows 7 Enterprise     | 33PXH-7Y6KF-2VJC9-XBBR8-HVTHH |
| Windows 7 Enterprise N   | YDRBP-3D83W-TY26F-D46B2-XCKRJ |
| Windows 7 Enterprise E   | C29WB-22CC8-VJ326-GHFJW-H9DH4 |

#### Windows Vista

| Operating system edition   | KMS Client Product Key        |
| -------------------------- | ----------------------------- |
| Windows Vista Business     | YFKBB-PQJJV-G996G-VWGXY-2V3X8 |
| Windows Vista Business N   | HMBQG-8H2RH-C77VX-27R82-VMQBT |
| Windows Vista Enterprise   | VKK3X-68KWM-X2YGT-QR4M6-4BWMV |
| Windows Vista Enterprise N | VTC42-BM838-43QHV-84HX6-XJXKV |

Key
https://learn.microsoft.com/zh-cn/windows-server/get-started/kms-client-activation-keys


---

### For activation of Office

Office (VOL version) activation steps (administrator command execution)
Go to the installation directory

The default for 32-bit is typical

~~~bash
cd "C:\Program Files (x86)\Microsoft Office\Office16"
~~~

The default for 64-bit is typical

~~~bash
cd "C:\Program Files\Microsoft Office\Office16"
~~~

> Office16 is Office 2016, Office15 is Office 2013, and Office14 is Office 2010.

Register the KMS service

~~~bash
cscript ospp.vbs /sethst:skms.netnr.eu.org
~~~


Activate Office

~~~bash
cscript ospp.vbs /act
~~~


Key of Office keys
https://docs.microsoft.com/en-us/DeployOffice/vlactivation/gvlks
Help

---

### Reference ###

- [One-click installation of KMS service scripts](https://teddysun.com/530.html)
- [teddysun/kms - Docker Image | Docker Hub](https://hub.docker.com/r/teddysun/kms)
- [GitHub - netnr/kms: KMS activates the service](https://github.com/netnr/kms)
- [KMS Activation Windows/Office Pocket Guide](https://blog.03k.org/post/kms.html)

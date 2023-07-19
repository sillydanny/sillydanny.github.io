---
title: "RSYNC USAGE"
date: 2023-06-08T14:37:31+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Linux
- Windows
tags:
- rsync
- synology
- OpenMediaVault
- OpenWRT
- OMV
- DSM
- openssl
ShowLastMod: true
cover:
    image: "img/rsync-usage/rsync-usage.png"
---

### Introduction

> `Rsync` is an open-source application that provides fast incremental or mirror backup by leveraging built-in data deduplication algorithms. It is included in almost all Linux distributions.

---

### Features

- Can update whole directory trees and filesystems
- Optionally preserves symbolic links, hard links, file ownership, permissions, devices and times
- Requires no special privileges to install
- Internal pipelining reduces latency for multiple files
- Can use rsh, ssh or direct sockets as the transport
- Supports anonymous rsync which is ideal for mirroring

---

### Basic Use

```bash 
rsync -option source/ destination/
```

| Option                 | Description                                          |
| ---------------------- | ---------------------------------------------------- |
| -v                     | Verbose mode, outputs detailed information           |
| -r                     | Recurse into directories                             |
| -a                     | Archive mode (-rlptgoD, no -A, -X, -U, -N, -H)       |
| -h                     | Output numbers in a human-readable format            |
| -z                     | Use compression to transfer data                     |
| -e                     | Specify the remote shell to use                      |
| -P                     | Same as --partial --progress                         |
| -W                     | Copy files whole (without delta-xfer algorithm)      |
| --progress             | Show progress during transfer                        |
| --delete               | Delete extraneous files from destination directories |
| --remove-source-files  | Sender removes synchronized files (non-dir)          |
| --exclude=PATTERN      | Exclude files matching PATTERN                       |
| --include=PATTERN      | Don't exclude files matching PATTERN                 |
| --copy-as=USER[:GROUP] | Specify user and optional group for the copy         |
| --chmod=CHMOD          | Affect file and/or directory permissions             |

---

### Samples

```bash 
rsync -avh /home/user/data/ /mnt/backup
```

Copy `/home/user/data/` (as source directory) to `/mnt/backup` (as destination directory), using the options `-avh`.

---

### Rsync Server Setup

`Rsync` can be used not only for local backups, but also to transfer data between different OSes (e.g. Windows, macOS, Linux, etc.). It can push data to a remote host (for backup) or pull from a remote host (for restore). However, an `rsync` daemon needs to be set up on one side.

#### 1. Set up Rsync Daemon on OpenWRT (Typical)

Install `Rsync` Daemon:

```bash
opkg update && opkg install rsyncd 
```

Two files are required:

| File                | Description                         |
| ------------------- | ----------------------------------- |
| /etc/rsyncd.conf    | Rsyncd config file                  |
| /etc/rsyncd.secrets | Rsyncd authentication password file |

For the `rsyncd` config file:

```bash
cat >> /etc/rsyncd.conf << EOF  
# /etc/rsyncd.conf
# Minimal configuration for rsync daemon  
  
# Next line required for init script  
pid file = /var/run/rsyncd.pid  
log file = /var/log/rsyncd.log  
use chroot = no  
uid = nobody  
gid = nogroup  
read only = no  
  
[Tools]  
        path = /mnt/Tools  
        comment = Shared Tools Folder over Rsync  
        read only = no  
        auth users = user01  
        secrets file = /etc/rsyncd.secrets  
  
  
[Media]  
        path = /mnt/Media  
        comment = Shared Media Folder over Rsync  
        read only = no  
        auth users = user02  
        secrets file = /etc/rsyncd.secrets
EOF
```

Two directory folders named `Tools` and `Media` are set up for sharing, and the users `user01` and `user02` are specified for each share.

For the `rsyncd` authentication password:

```bash
cat >> /etc/rsyncd.secrets << EOF 
user01:P@ssw0rd01  
user02:P@ssw0rd02  
EOF
```

This defines two users and their passwords.

(OPTIONAL) Generating a Random Password with ‘OpenSSL’

To generate a pseudo-random password, we can use the OpenSSL via syntax:

~~~bash
$  openssl rand -base64 30
~~~

> -base64 option is used for encoding the output with length 30 characters.


Assign permissions to the password file:

```bash 
chmod 600 /etc/rsyncd.secrets
```

This avoids the error `"@ERROR: auth failed on module"` for security.

Restart the `rsyncd` service:

```bash
/etc/init.d/rsyncd restart 
```

Or **reboot**.

#### 2. Set up Rsync Daemon on OMV (OpenMediaVault)

To enable the Rsync Daemon Server:

![2023-06-08_095505](/img/rsync-usage/2023-06-08_095505.png)

Add a share folder named "Media"

![2023-06-08_095840](/img/rsync-usage/2023-06-08_095840.png)

Create an account for authorization

![2023-06-08_100036](/img/rsync-usage/2023-06-08_100036.png)

#### 3. Set up Rsync Daemon on DSM (Synology)

![2023-06-08_101827](/img/rsync-usage/2023-06-08_101827.png)

`Enable rsync service`

> Go to **Control Panel** > **File Services** > **rsync**, and tick **Enable rsync service**.

`Enabling rsync Accounts`

> 1. Go to **Control Panel** > **File Services** > **rsync**, and tick **Enable rsync account**.
> 2. Click **Edit rsync Account** > **Add** to configure users

`Assign user "rsync" to directory and privileges`

![2023-06-08_105711](/img/rsync-usage/2023-06-08_105711.png)

---

### Rsync Client Setup

`Rsync` is not only useful for local backups, but it can also be used to transfer data between different OS such as Windows, macOS, and Linux. You can use `PUSH` (backup to remote) or `PULL` (backup to local), but a server daemon is required.

#### 1. Set up Rsync client on OpenWRT (Typical)

To install the `rsync` service:

~~~bash
opkg update && opkg install rsync
~~~

To backup using interactive mode:

~~~bash
rsync -avz /mnt/Tools/ user01@10.1.1.254::Tools/
## You will be prompted to insert an authorization password for the user named user01
P@ssw0rd01
~~~

**<u>Alternatively</u>**, create a `Rsync` password file to store each user's password to avoid having to insert the password each time:

~~~bash
echo "P@ssw0rd01" >> /etc/rsync.passwd 
~~~

>The file stored password is "P@ssw0rd01".

You can create other password files as you have more than one user. For example, `/etc/rsync.passwd2`, and assign the file `600` permission:

~~~bash
chmod 600 /etc/rsync.passwd
~~~

To upload local data to a remote server, use the following syntax:

~~~bash
rsync -avz /mnt/Tools/ user01@10.1.1.254::Tools/ --password-file=/etc/rsync.passwd
~~~

To download files from remote to local:

~~~bash
rsync -avz user02@10.1.1.254::Media/ /mnt/Media/ --password-file=/etc/rsync.passwd
~~~


#### 2. Set up Rsync client on OMV (OpenMediaVault)

In this screenshot, the remote folder's data (Media) is being downloaded to the local harddisk.

![2023-06-08_100505](/img/rsync-usage/2023-06-08_100505.png)

#### 3. Set up Rsync client on Windows

Install `Rsync` client software like a Linux through [Chocolatey](https://chocolatey.org/install):

~~~powershell
choco install rsync -y
~~~

Use the following syntax to transfer files:

~~~powershell
rsync.exe -avhz --progress --update --chmod=ugo=rwX /cygdrive/c/tools /cygdrive/d/Other/
## "/cygdrive/c" indicates Driver "C:\" in Windows
~~~

![2023-06-07_135935](/img/rsync-usage/2023-06-07_135935.png)

---

### Schedule a shell script to run using a CRON job on Linux

Create a shell script:

```bash
cat >> /root/rsync_bak.sh << EOF
#!/bin/bash

# Variables
OPTS="-avzP --delete"
LOG_DIR="/media/Tools/Tutorial/typecho/DNMP/logs"
BASE_DIR="/media/Tools/Tutorial/typecho/DNMP"
REMOTE_DIR="/Apps/DNMP"
HOST="REMOTE_SERVER_IP"
USER="opc"

# Log files
APPS_LOG="--log-file=${LOG_DIR}/Apps_$(date +'%Y-%m-%d-%H-%M-%S').txt"

# Rsync commands
rsync $OPTS $APPS_LOG -e ssh ${USER}@${HOST}:${REMOTE_DIR}/apps ${BASE_DIR}

# Delete log files older than 30 days
find ${LOG_DIR}/*.txt -mtime +30 -exec rm {} \;
EOF
```

Assign execute permission to the shell script:

~~~bash
chmod +x /root/rsync_bak.sh
~~~

Edit the crontab file to schedule the job:

~~~bash
crontab -e
~~~

Add the following syntax to the end of the file:

~~~bash
0 1 * * * sh /root/rsync_bak.sh 2>&1
## This will start the job at 1:00 a.m. every day.
~~~

---

### Conclusion

> `Rsync` is a useful backup tool that provides fast incremental file transfer and supports various types of operating systems.
>
> Finally, I strongly recommend using the '`-e ssh`' option to transfer data with public key, as it provides better security through an encrypted tunnel.

---

### Reference

- [rsync (samba.org)](https://rsync.samba.org/)
- [Rsync | DSM - Synology Knowledge Center](https://kb.synology.com/en-us/DSM/help/DSM/AdminCenter/file_rsync?version=7)
- [RSync — openmediavault 6.x.y documentation](https://docs.openmediavault.org/en/latest/administration/services/rsync.html)
- [Linux 使用 rsync 遠端檔案同步與備份工具教學與範例](https://blog.gtwang.org/linux/rsync-local-remote-file-synchronization-commands/)
- [rsyncd in openWRT | #Villa's syslog (villasyslog.net)](https://villasyslog.net/rsyncd-in-openwrt/)

---

### Related

- [RSYNC USAGE](https://kingtam.eu.org/posts/rsync-usage/)
- [Synchronization Solution on Windows (RSYNC)](https://blog.kingtam.cf/posts/rsync-windows/)

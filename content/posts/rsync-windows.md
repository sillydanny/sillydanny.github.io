---
title: "Synchronization Solution on Windows (RSYNC)"
date: 2023-06-09T09:34:28+08:00
draft: false
author: "King Tam"
summary: "Synchronization Solution on Windows (RSYNC)" # 首頁顯示的文字總結段落
showToc: true
categories:
- Windows 
tags:
- rsync
ShowLastMod: true
cover:
    image: "img/rsync-windows/rsync-windows.jpg"
---



[img from unsplash](https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80)

> These are the basic steps to set up and use an `rsync` tool for synchronization on Windows.

---


<table><tr><td bgcolor=#8ACC7B style="text-align: center; vertical-align: middle;"><font size=4 color=white><b>RSYNC Server</b></font></td></tr></table>

### Setup RSYNC Server on Windows

<mark>**i. Manual Setup** </mark>

1. Install RSYNC on the server machines.
   Install `Rsync` software like a linux through [Chocolatey](https://chocolatey.org/install)

~~~powershell
choco install rsync -y
~~~


2. On the server, create a folder to share

~~~powershell
mkdir -p C:\rsync_share
~~~

![2023-06-08_164244](/img/rsync-windows/2023-06-08_164244.png)

e.g. `C:\rsync_share`. as rsync share folder.

3. On the server,Create the `C:\rsync\rsyncd.conf` file with the following contents:

```
[rsync_share]
path = /cygdrive/c/rsync_share
use chroot = no
ignore errors
read only = no
list = yes
```

This configures the share name as "**rsync_share**" pointing to the `C:\rsync_share` folder.

Use `cygdrive path prefix` as `/cygdrive/c/rsync_share`

4. On the server, open PowerShell and run the rsync daemon:

```powershell
rsync --daemon --config=C:\rsync\rsyncd.conf
```

This will run the rsync daemon using the config file `C:\rsync\rsyncd.conf`.

5. You may need to configure **firewall** rules on the server to allow incoming `TCP` connections to port `873`

   ![2023-06-08_151454](/img/rsync-windows/2023-06-08_151454.png)

   (The rsync daemon default port).

6. Rsync service is set to run automatically on startup on the server via "**Task Scheduler**".

![2023-06-08_151641](/img/rsync-windows/2023-06-08_151641.png)

![2023-06-08_151656](/img/rsync-windows/2023-06-08_151656.png)



---



<mark>**ii. Automatic via Script** </mark>

> Here are Windows scripts to automatically install `rsync`, configure it, and open the firewall port:

1. Update Policy to allow execute self PowerShell script.

~~~powershell
Set-ExecutionPolicy RemoteSigned
~~~

> Execution Policy Change
> The execution policy helps protect you from scripts that you do not trust. Changing the execution policy might expose
> you to the security risks described in the about_Execution_Policies help topic at
> https:/go.microsoft.com/fwlink/?LinkID=135170. Do you want to change the execution policy?
> [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): <mark>**y**</mark>




2. Create Windows PowerShell Script

> Save all below content to a PowerShell script as names "rsync-config.ps1"

~~~powershell
# Create rsync config and share folders
New-Item -Path C:\rsync -ItemType Directory
New-Item -Path C:\rsync_share -ItemType Directory

# Create rsync.conf file
@"
[rsync_share]
path = /cygdrive/c/rsync_share
ignore errors
read only = no
list = yes
auth users = rsync
secrets file = /cygdrive/c/rsync/rsync.passwd
"@ | Add-Content -Path C:\rsync\rsyncd.conf

# Open port 873 for rsync
New-NetFirewallRule `
    -Name "Rsync Daemon (873)" `
    -DisplayName "Rsync Daemon (873)" `
    -Protocol TCP `
    -LocalPort 873

# Create scheduled task to run rsync daemon
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Action = New-ScheduledTaskAction `
    -Execute "Powershell.exe" `
    -Argument "rsync --daemon --config=C:\rsync\rsyncd.conf"
Register-ScheduledTask `
    -TaskName "Rsync Daemon" `
    -Trigger $Trigger `
    -Action $Action `
    -RunLevel Highest `
    -User System
~~~



| Parameter                                     | Description                                                  | Path                  |
| --------------------------------------------- | ------------------------------------------------------------ | --------------------- |
| rsync                                         | Configuration folder for rsync                               | C:\rsync\             |
| rsync_share                                   | Shared folder for rsync                                      | C:\rsync_share\       |
| /cygdrive/c/rsync_share                       | Cygwin path prefix up to the shared folder location          | C:\rsync_share\       |
| auth users = rsync                            | Specifies that only the "`rsync`" user can connect           |                       |
| secrets file = /cygdrive/c/rsync/rsync.passwd | Specifies the location of the password file that will be used for authenticating rsync connections. | C:\rsync\rsync.passwd |

The format of the `rsync password file`(C:\rsync\rsync.passwd) is as follows:

```bash
username:password
```


- `username`: This is the username for the rsync account.
- `password`: This is the password for the rsync account.

Each line in the file represents a single `rsync` account. Create multiple accounts by adding additional lines to the file.



3. Execute the PowerShell Script

![2023-06-08_151758](/img/rsync-windows/2023-06-08_151758.png)

> run on Windows server to automatically setup rsync daemon, create share folder names "rsync_share" and configure the firewall. moreover, the rsync service startup on reboot.

---

<table><tr><td bgcolor=#D0402F style="text-align: center; vertical-align: middle;"><font size=4 color=white><b>RSYNC Client</b></font></td></tr></table>

### Setup RSYNC Client on Windows

Install RSYNC on the client machines.
Install `Rsync` software like a linux through [Chocolatey](https://chocolatey.org/install)

~~~powershell
choco install rsync -y
~~~

### Operating

<mark>**i. Manual** </mark>

On the client PC, create a folder to store `rsync` data

~~~powershell
mkdir -p C:\rsync_client
~~~

>     Directory: C:\
>
>
> Mode                 LastWriteTime         Length Name
>
> ----                 -------------         ------ ----
>
> d-----         7/11/2023  12:46 PM                rsync_client

For example:

To sync files from client to server (**PUSH**):

```powershell
rsync -avz /cygdrive/c/rsync_client  rsync://server_ip_address/rsync_share
```

To sync files from server to client (**PULL**):

```powershell
rsync -avz rsync://server_ip_address/rsync_share /cygdrive/c/rsync_client
```



To sync files from server to client with `--progress` flag on Linux

```bash
rsync -avz --progress --update --chmod=ugo=rwX --delete rsync://server_ip_address/rsync_share ./rsync_client
```


To sync files from client to server with `--password-file` flag on Linux

~~~bash
rsync -avz --password-file=<(echo "your_password") /cygdrive/c/rsync_client rsync://server_ip_address/rsync_share
~~~



![2023-06-08_163246](/img/rsync-windows/2023-06-08_163246.png)

| Option                                  | Description                                                  |
| --------------------------------------- | ------------------------------------------------------------ |
| `-a`                                    | Enables archive mode                                         |
| `-v`                                    | Enables verbose output                                       |
| `-z`                                    | Enables compression                                          |
| `--progress`                            | Displays progress during the transfer                        |
| `--update`                              | Skips files that are newer on the destination                |
| `--chmod=ugo=rwX`                       | Sets permissions of synced files                             |
| `--delete`                              | Removes files on the destination that do not exist on the source |
| `rsync://server_ip_address/rsync_share` | Specifies the remote directory as r`sync_share`              |
| `./ClientFolder`                        | Specifies the current directory on the local machine         |

<mark>**i. Automatic via Script** </mark>

Update Policy to allow execute self PowerShell script.

~~~powershell
Set-ExecutionPolicy RemoteSigned
~~~

2. Create Windows PowerShell Script

> Save all below content to a PowerShell script as names "rsync-client.ps1"

~~~powershell
# Set variables
$RsyncPullFolder = "C:\rsync_pull"
$RsyncConfigFolder = "C:\rsync"
$Source = "/cygdrive/c/rsync_pull"
$Destination = "rsync_server_ip::share"
$Username = "rsync"
$Password = "P@ssw0rd123!"
$TaskName = "Rsync Pull"
$TriggerTime = "08:00"


# Check if rsync_pull and rsync folders exist, and create them if they don't
if (!(Test-Path $RsyncPullFolder)) {
    New-Item -ItemType Directory -Path $RsyncPullFolder
}
if (!(Test-Path $RsyncConfigFolder)) {
    New-Item -ItemType Directory -Path $RsyncConfigFolder
}
New-Item -Path "$RsyncConfigFolder" -Name "rsync.passwd" -ItemType "File"
Add-Content -Path "$RsyncConfigFolder\rsync.passwd" -Value "$Password"


# Build rsync command
$RsyncCommand = "rsync -avz --progress --update --chmod=ugo=rwX --delete --password-file=/cygdrive/c/rsync/rsync.passwd $Username@$Destination $Source"

# Create scheduled task to run rsync command
$Trigger = New-ScheduledTaskTrigger -Daily -At $TriggerTime
$Action = New-ScheduledTaskAction -Execute "Powershell.exe" -Argument "$RsyncCommand"
Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Action $Action -RunLevel Highest -User "SYSTEM"
~~~

| Variable             | Description                                                  |
| -------------------- | ------------------------------------------------------------ |
| `$RsyncPullFolder`   | Specifies the download directory on the local machine        |
| `$RsyncConfigFolder` | Specifies the config file storage directory on the local machine |
| `$Source`            | Specifies the source directory on the local machine          |
| `$Destination`       | Specifies the destination directory on the remote server     |
| `$Username`          | Specifies the username of the `rsync` user on the remote server |
| `$Password`          | Specifies the password for the `rsync` user on the remote server |
| `$TaskName`          | Specifies the name of the scheduled task                     |
| `$TriggerTime`       | Specifies the time when the scheduled task will run          |

This script runs on a Windows client and automatically sets up an rsync schedule, creates an rsync folder named 'rsync_pull', and configures the username and password for authorization.

---

### Conclusion

> `rsync` can be a reliable and efficient solution for file synchronization on Windows, with its ability to preserve file attributes, compress data during transfer, and show verbose output.
>
> To use `rsync` on Windows, you can install a version of rsync compatible with Windows, configure your system's firewall and network settings, and create a configuration file to specify the files and directories to be synced.

---

### Reference

- [How-to Run a PowerShell Script](https://lazyadmin.nl/powershell/run-a-powershell-script/)
- [The cygdrive path prefix](https://cygwin.com/cygwin-ug-net/using.html)

---

### Related

- [RSYNC USAGE](https://kingtam.eu.org/posts/rsync-usage/)

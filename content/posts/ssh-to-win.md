---
title: "Seamless SSH Access: Auto-Launch Git Bash on Windows 10 After Login"
date: 2025-01-27T20:21:41+08:00
draft: false
author: "King Tam"
summary: "Set Git Bash as the Default Shell for SSH on Windows 10" 
showToc: true
categories:
- Windows 
tags:
- ssh
- git
ShowLastMod: true
cover:
    image: "img/ssh-to-win/ssh-to-win.jpeg"
---


# Set Git Bash as the Default Shell for SSH on Windows 10


> To make Git Bash the default shell for SSH connections on a Windows 10 machine, follow these steps:

### Step 1: Enable SSH Server on Windows 10

Open <mark>**PowerShell** as an **Administrator**.</mark>

Install OpenSSH Server:

```sh
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```



Enable and Start the SSH Server:

```sh
Set-Service -Name sshd -StartupType 'Automatic'
Start-Service -Name sshd
```



### Step 2: Install Git via Chocolatey

Install Chocolatey:

```shell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```



Install Git:

```shell
choco install git -y
```



### Step 3: Set Git Bash as the Default Shell for SSH

Run the following command to set Git Bash as the default shell for the SSH service:

This command updates the registry to make Git Bash the default shell for SSH connections.

```sh
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name "DefaultShell" -Value "C:\Program Files\Git\bin\bash.exe" -PropertyType String -Force
```



### Step 4: Test SSH Login

On another machine, open a terminal and try logging in via SSH:

Upon successful login, you should be automatically switched to Git Bash.

```sh
ssh <username>@<your-windows-machine>
```

e.g. `ssh user01@10.1.1.254`


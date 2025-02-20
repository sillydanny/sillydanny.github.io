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



---

## Key-based authentication in OpenSSH for Windows

1. **Move to the .ssh Directory(<mark>*Client*</mark>)**: 

   ```
   cd .ssh
   ```

   Changes the current directory to `.ssh`, which typically stores SSH keys.

2. **Generate a New SSH Key Pair**:

   ```bash
   ssh-keygen
   ```

   |-- id_rsa
   
   |-- id_rsa.pub

3. **Copy the Public Key to the Remote Server**:

   as name: `administrators_authorized_keys`

   ![2025-02-15_102155](/img/ssh-to-win/2025-02-15_102155.png)

   ```bash
   scp id_rsa.pub admin@10.2.2.80:administrators_authorized_keys
   ```

   Uses `scp` (secure copy) to transfer the public key file `id_rsa.pub` to the remote server at IP `10.2.2.80`. The file will be saved as `administrators_authorized_keys` on the remote server under the `admin` user's home directory.

4. **SSH into the Remote Server(<mark>*Server*</mark>)**:

   ```bash
   ssh USER@RemoteIP
   ```

   SSH connection to the remote server specified by `RemoteIP` using the `USER` account. 

   ```bash
   ssh admin@10.2.2.80
   ```

   `admin` as username and `10.2.2.80` with the IP address of the remote server.

5. **Move the Key File to the SSH Configuration Directory**:

   ```bash
   move administrators_authorized_keys %ProgramData%\ssh
   ```

   Moves the `administrators_authorized_keys` file to the `%ProgramData%\ssh` directory, which is where Windows stores SSH configuration files.

6. **Move to the SSH Directory**:

   ```bash
   cd %ProgramData%\ssh
   ```

   Changes the current directory to `%ProgramData%\ssh`.

7. **Set Permissions on the Authorized Keys File**:

   bash

   ```bash
   icacls administrators_authorized_keys /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
   ```

   Modifies the permissions of the `administrators_authorized_keys` file. It removes inherited permissions and grants full control to the `Administrators` group and the `SYSTEM` account.

8. Use the SSH keys to connect to a remote system without using passwords(<mark>*Test*</mark>).

```bash
ssh -tq admin@10.2.2.80 "shutdown -s -f -t 0
```

> Connects to a remote server without a password, immediately shuts down the remote server, force-closing all applications.



### Related

- [Key-based authentication in OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement)
- [SSH Tunneling](https://kingtam.eu.org/posts/ssh-tunneling/)
- [Secure Linux Login Connection](https://kingtam.eu.org/posts/ssh-key/)


---
title: "Set Git-Bash as Default Shell in Windows Terminal"
date: 2023-06-09T15:32:51+08:00
draft: false
author: "King Tam"
summary: "Set Git-Bash as Default Shell in Windows Terminal" 
showToc: true
categories:
- Windows
tags:
- git
ShowLastMod: true
cover:
    image: "img/windows-git/windows-git.jpg"
---

# Set Git-Bash as Default Shell in Windows Terminal #

### Why Git Bash ###

> - Both Command Prompt (CMD) and Unix (Bash) commands can be run in Git Bash.
> - Small and Fast.

---


### Prerequisites ###

<span id="wt"></span>

- Windows Terminal

  > Install Windows Terminal from the Microsoft Store.

![2023-01-06_113337.png](/img/windows-git/2023-01-06_113337.png)



<span id="choco"></span>



- Chocolatey

  > Chocolatey has the largest online registry of Windows packages.
  > [Installing Chocolatey](https://chocolatey.org/install)




<span id="git"></span>



- Git Bash

  > Easy way to install Git Bash via Chocolatey.

```bash
choco install git -y
```

![2023-01-05_200058](/img/windows-git/2023-01-05_200058.png)


### Add Git Bash to Windows Terminal

<span id="guid"></span>



- Generate a new GUID

  > Run the following command in PowerShell.

```bash
[guid]::NewGuid()
```

![GUID](/img/windows-git/2023-01-05_201842.png)



<span id="profile"></span>




- Added to Windows Terminal profile

> Go to Windows Terminal settings via shortcut key `Ctrl + ,`


![pic alt](/img/windows-git/2023-01-05_202346.png)

```bash
            {
                "antialiasingMode": "cleartype",
                "commandline": "%PROGRAMFILES%/Git/usr/bin/bash.exe -i -l",
                "guid": "{f9934442-d71c-40b6-b804-717659fa8640}",
                "historySize": 3000,
                "icon": "%PROGRAMFILES%/Git/mingw64/share/git/git-for-windows.ico",
                "name": "Git-Bash",
                "startingDirectory": "%USERPROFILE%"
            }
```

> The GUID `f9934442-d71c-40b6-b804-717659fa8640` is previous command generated.

- Set "Git Bash" as the default terminal

![pic alt](/img/windows-git/2023-01-10_160726.png)

Save the Settings.

---

<span id="ref"></span>

### Reference:

[Generate a GUID in Windows 10](https://winaero.com/generate-new-guid-in-windows-10/)
[How to add Git Bash to Windows Terminal](https://walterteng.com/how-to-add-git-bash-to-windows-terminal)
[Windows Terminal's 設定 Git Bash 和 SSH](https://magicjackting.pixnet.net/blog/post/225162505-windows-terminal's-%E8%A8%AD%E5%AE%9A-git-bash-%E5%92%8C-ssh)


---

### Related:

- [Linux Terminal Tab Completion](https://kingtam.eu.org/posts/linux-inputrc/)
- [Set Git-Bash as Default Shell in Windows Terminal](https://kingtam.eu.org/posts/windows-git/)

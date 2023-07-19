---
title: "Use WINSW To Setup FRP As Windows Service"
date: 2023-05-30T10:06:48+08:00
draft: false
author: "King Tam"
summary: "" # 首頁顯示的文字總結段落
showToc: true
categories:
- Windows 
tags:
- winsw
- frp
- frpc
- reverse proxy
ShowLastMod: true
cover:
    image: "img/winsw-frpc/winsw-frpc-service.jpg"
---


### About:

`WinSW` is a utility that allows you to wrap and manage a Windows service for any executable. 

`frpc` is a client for the `frp` (Fast Reverse Proxy) tool, which enables you to expose local servers to the internet. 

---

### Procedure:

To set up `frpc` as a Windows service using `WinSW`, follow these steps:

1. Download `WinSW`

- Download the latest release of WinSW from the [releases page](https://github.com/winsw/winsw/releases). Choose the appropriate executable for your system, either `WinSW-x64.exe` or `WinSW-x86.exe`.

2. Rename `WinSW` executable

- Rename the downloaded `WinSW` executable to `frpc-winsw.exe`. This will be the service wrapper for the `frpc` executable.

3. Create a configuration file

- Create a new XML configuration file named `frpc-winsw.xml` in the same directory as the `frpc-winsw.exe`. Add the following content to the file:

```xml
<service>
  <id>frpc</id>
  <name>frpc</name>
  <description>frp client service managed by WinSW</description>
  <executable>path\to\frpc.exe</executable>
  <arguments>-c path\to\frpc.ini</arguments>
  <log mode="roll-by-size">
    <sizeThreshold>10485760</sizeThreshold>
    <keepFiles>3</keepFiles>
  </log>
  <onfailure action="restart" />
  <startmode>Automatic</startmode>
</service>
```

- Replace `path\to\frpc.exe` with the actual path to your `frpc.exe` file.
- Replace `path\to\frpc.ini` with the actual path to your `frpc.ini` configuration file.



![](/img/winsw-frpc/2023-05-30_tree.png)



4. Install the service

- Open a command prompt or PowerShell window with administrator privileges. Navigate to the directory containing `frpc-winsw.exe` and `frpc-winsw.xml`.
- Run the following command to install the service:

```powershell
.\frpc-winsw.exe install
```

> Installing service 'frpc (frpc)'...
> Service 'frpc (frpc)' was installed successfully.


5. Start the service

- After installing the service, start it by running the following command:

```powershell
.\frpc-winsw.exe start
```

> Service 'frpc (frpc)' was refreshed successfully.
>
> Starting service 'frpc (frpc)'...
> Service 'frpc (frpc)' started successfully.

---

Also, we can restart a Windows service from the command line (alternative)

~~~powershell
 net stop frpc
~~~

> The frpc service is stopping.
> The frpc service was stopped successfully.

~~~powershell
net start frpc
~~~

> The frpc service is starting.
> The frpc service was started successfully.

![](/img/winsw-frpc/2023-05-30_092634.png)

---

### Conclusion:

 `frpc` is set up as a Windows service and will automatically start on system boot. You can manage the service using the `Services` management console or by using the `frpc-winsw.exe` commands, such as `stop`, `restart`, and `uninstall`.

---

### Reference:

- [WinSW documentation](https://github.com/winsw/winsw/blob/master/doc/xmlConfigFile.md) 
- [frp documentation](https://github.com/fatedier/frp/blob/master/README.md).



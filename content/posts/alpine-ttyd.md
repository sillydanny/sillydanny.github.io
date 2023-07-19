---
title: "Alpine Linux share the terminal over the web (ttyd)"
date: 2023-05-26T12:03:43+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- ttyd
cover:
    image: "img/alpine-ttyd/alpine-ttyd.jpg"
---



<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>What is ttyd?</b> </font></td></tr></table>

### What is ttyd?

> `ttyd` is a simple command-line program that allows you to share a terminal session over the web. It provides a web-based terminal interface for interacting with a Linux system, making it possible to access the system remotely from a web browser.

---





<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Install ttyd in Alpine Linux</b> </font></td></tr></table>

### Install ttyd in Alpine Linux

Open the terminal and type the following command to update the packages list:

~~~bash
apk update
~~~






Install the ttyd package by typing the following command:

~~~bash
apk add ttyd
~~~






Once the installation is complete, you can use the ttyd command to start the ttyd server.

For example, to start the ttyd server on port 7681, use the following command:

~~~bash
ttyd -p 7681 /bin/sh
~~~







This command will start the ttyd server and run the `/bin/sh` shell in it.

You can now access the ttyd server by opening a web browser and navigating to `http://<ip_address>:7681`.

> Replace `<ip_address>` with the IP address of the server where the ttyd server is running.

That's it! You have now installed and started the ttyd server on Alpine Linux.

---


<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Make ttyd start-up on boot </b> </font></td></tr></table>

### Make ttyd start-up on boot


Create a new file in the `/etc/init.d/` directory using your preferred text editor. For example, you can use the following command to create a file named `ttyd`:

~~~bash
vi /etc/init.d/ttyd
~~~



Add the following content to the `ttyd` file:

~~~bash
#!/sbin/openrc-run

description="ttyd service"
command="/usr/bin/ttyd -p 7681 login &"
command_args=""
pidfile="/run/ttyd.pid"

depend() {
    after network
}

start_pre() {
    mkdir -p /run/ttyd
}
~~~

| Option        | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| /usr/bin/ttyd | Specifies the path to the `ttyd` binary.                     |
| -p 7681       | Specifies the port number that `ttyd` should listen on for incoming connections. In this case, it is set to 7681 (default). |
| login         | Specifies the command to run after a user connects to `ttyd`. In this case, it is set to `login`, which starts a new login session. |
| &             | Runs the command in the background, allowing the terminal to be used for other commands while `ttyd` continues to run. |



Creates a new service definition for ttyd, defining the command to run and the PID file location.

Adjust the `command` line to use your desired options for `ttyd`.

Save and exit the file.

Make the `ttyd` script executable using the following command:

~~~bash
chmod +x /etc/init.d/ttyd
~~~






Add the `ttyd` service to the startup list using the following command:

~~~bash
rc-update add ttyd
~~~


> * service ttyd added to runlevel default




This command adds the `ttyd` service to the default runlevel, so it will start up automatically on boot.

That's it! You have now configured ttyd to start up on boot in Alpine Linux.

---


<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Conclusion</b> </font></td></tr></table>

### Conclusion

`ttyd`, which allows users to interact with the shell session in real-time using a web-based terminal interface.
`ttyd` also is a useful tool for remote administration and troubleshooting of Linux systems. 

---



<table><tr align="left"><td bgcolor=#25add7><font size=3 color=white><b>Related</b> </font></td></tr></table>

### Related

- [OneCloud Gen1 - OpenWRT Install TTYD](https://kingtam.win/archives/onecloud.html#Step06)

- [OneCloud Gen2 - Armbian Install TTYD](https://kingtam.win/archives/onecloud2.html#ttyd)

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)

- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)

- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)

- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)

- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)

- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)

- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)

  [1]: https://kingtam.win/usr/uploads/2023/05/837274182.png
---
title: "Set up SmartDNS in Alpine Linux (LXC)"
date: 2023-05-26T12:08:55+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- dns
- smartdns
cover:
    image: "img/alpine-smartdns/alpine-smartdns.jpg"
---

# Set up SmartDNS in Alpine Linux (LXC)

![smartdns-banner.png](/img/alpine-smartdns/smartdns-banner.png)

> SmartDNS is a local DNS server that retrieves DNS query results from multiple upstream DNS servers and delivers the fastest results to clients. 
> It supports secure DNS protocols such as DoT (DNS over TLS) and DoH (DNS over HTTPS), providing enhanced privacy protection, avoiding DNS pollution, and improving network access speed. 
> Additionally, SmartDNS supports high-performance ad filtering for an overall better browsing experience

---

<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Features</b> </font></td></tr></table>



- Multiple upstream DNS servers
- Return the fastest IP address
- Support for multiple query protocols
- Domain IP address specification
- Domain name high-performance rule filtering
- Linux/Windows multi-platform support
- Support IPV4, IPV6 dual stack
- DNS64
- High performance, low resource consumption
- DNS domain forwarding



---

<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Architecture</b> </font></td></tr></table>



![architecture.png](/img/alpine-smartdns/architecture.png)

---

<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Install SmartDNS on Alpine Linux (PVE LXC)</b> </font></td></tr></table>



>  Here is how to install SmartDNS on Alpine Linux running in a Proxmox VE LXC container

Download the latest version of SmartDNS from [official website](https://github.com/pymumu/smartdns/releases/tag/Release42)

~~~bash
wget https://github.com/pymumu/smartdns/releases/download/Release42/smartdns.1.2023.05.07-1641.x86_64-linux-all.tar.gz
~~~

> Connecting to github.com (20.205.243.166:443)
> Connecting to objects.githubusercontent.com (185.199.111.133:443)
> saving to 'smartdns.1.2023.05.07-1641.x86_64-linux-all.tar.gz'
> smartdns.1.2023.05.0 100% |******************************************************************************************| 1628k  0:00:00 ETA
> 'smartdns.1.2023.05.07-1641.x86_64-linux-all.tar.gz' saved

Start to install

~~~bash
tar -zxf smartdns.1.2023.05.07-1641.x86_64-linux-all.tar.gz && cd smartdns/ && chmod +x ./install
./install -i
~~~

> created directory: '/etc/smartdns'
> 'usr/sbin/smartdns' -> '/usr/sbin/smartdns'
> 'etc/smartdns/smartdns.conf' -> '/etc/smartdns/smartdns.conf'
> install: can't create '/etc/default/smartdns': No such file or directory

---

copy the execute file to binaries with superuser (root) privileges directory

~~~bash
cp ~/smartdns/usr/sbin/smartdns /usr/sbin/
~~~

backup original SmartDNS configuration file

~~~bash
mv /etc/smartdns/smartdns.conf /etc/smartdns/smartdns.conf.bak
~~~

create a new SmartDNS configuration file

> Official reference: https://pymumu.github.io/smartdns/en/config/basic-config/

~~~bash
cat >> /etc/smartdns/smartdns.conf << EOF
server-name smartdns
bind :53
bind-tcp :53
cache-size 3096
cache-file /tmp/smartdns.cache
cache-persist yes
tcp-idle-time 120
rr-ttl 600
rr-ttl-min 60
rr-ttl-max 600
rr-ttl-reply-max 60
local-ttl 60
prefetch-domain yes
max-reply-ip-num 1
log-level info
log-size 128K
#-------dns-----------
server-https https://cloudflare-dns.com/dns-query
server-tls 1.1.1.1:853
server-tls 8.8.4.4:853
server-tls 9.9.9.9:853
server-tcp 114.114.114.114:53
server-tcp 223.5.5.5:53
server-tcp 180.76.76.76:53
server-tcp 202.99.160.68:53
server-tpc 8.8.4.4:53                            
server-tpc 9.9.9.9:53        
#----------------            
speed-check-mode ping,tcp:80,tcp:443
response-mode fastest-ip            
serve-expired yes                   
force-AAAA-SOA yes 
EOF
~~~

Disable DNS queries from UDHCP

~~~bash
sed -i 's/^RESOLV_CONF/#RESOLV_CONF/' /usr/share/udhcpc/default.script
~~~

Update the nameserver to localhost from `/etc/resolv.conf`  in the PVE's LXC

![2023-05-11_112825.png](/img/alpine-smartdns/2023-05-11_112825.png)

Enable the service to start on boot

~~~bash
echo 'nohup /usr/sbin/smartdns -f -c /etc/smartdns/smartdns.conf >/dev/null 2>&1 &' >> /etc/local.d/smartdns.start
chmod +x /etc/local.d/smartdns.start
rc-update add local
~~~

Now Apply setting and functions by reboot

~~~bash
reboot
~~~

---



<table><tr align="left"><td bgcolor=#fe3748><font size=3 color=white><b>Create a systemd service file for SmartDNS (alternative)</b> </font></td></tr></table>


Create a new systemd service file at `/etc/init.d/smartdns` 

```sh
touch /etc/init.d/smartdns
chmod +x /etc/init.d/smartdns
```

Add the following content to the file:

```sh
cat >> /etc/init.d/smartdns << EOF
#!/sbin/openrc-run

name="SmartDNS"
command="/usr/sbin/smartdns"
command_args="-c /etc/smartdns/smartdns.conf"
pidfile="/var/run/smartdns.pid"

depend() {
    need net
    after firewall
}
EOF
```

Save and exit the text editor.

 **Enable and start SmartDNS**

```sh
rc-update add smartdns default
rc-service smartdns start
```

Now, set to start on boot on your Alpine Linux system.


---

<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Ad Blocking by SmartDNS</b> </font></td></tr></table>



> SmartDNS can block ads by returning SOA for the corresponding domain name.
> Official reference: https://pymumu.github.io/smartdns/en/config/ad-block/

Create a script to download the `anti-ad-smartdns.conf` file from the community URL

```bash
cat >> /root/adblock-smartdns-conf.sh << EOF
#!/bin/bash
wget https://github.com/privacy-protection-tools/anti-AD/blob/master/anti-ad-smartdns.conf -O /etc/smartdns/anti-ad-smartdns.conf
EOF
```

Make the script executable:

```bash
chmod +x /root/adblock-smartdns-conf.sh
```

Open the `crontab` editor:

```bash
crontab -e
```

Add the following line to the end of the file to run the script every day at 1:00 AM:

```bash
0 1 * * * /root/adblock-smartdns-conf.sh
```

Modify the `/etc/smartdns/smartdns.conf` file to include the above configuration file:

~~~bash
conf-file /etc/smartdns/anti-ad-smartdns.conf
~~~



---

<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Reference</b> </font></td></tr></table>

### 



- [Linux - SmartDNS](https://pymumu.github.io/smartdns/en/install/linux/)
- [SmartDNS Releases](https://github.com/pymumu/smartdns/releases/tag/Release42)

- [Alpine linux系統安裝smartDNS伺服器實現DNS防污染快速查詢](https://www.wanuse.com/2022/10/alpine-linuxsmartdnsdns.html)



---



<table><tr align="left"><td bgcolor=#25add7><font size=5 color=white><b>Related</b> </font></td></tr></table>

### 


- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)

- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)

- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)

- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)

- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)

- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)

- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)

  [1]: https://kingtam.win/usr/uploads/2023/05/3044580802.png
  [2]: https://kingtam.win/usr/uploads/2023/05/3789771522.png
  [3]: https://kingtam.win/usr/uploads/2023/05/2426847579.png
---
title: "Create a reverse proxy for ARIA2's JSONRPC using NPM"
date: 2023-07-05T15:57:26+08:00
draft: false
author: "King Tam"
summary: "Create a reverse proxy for ARIA2's JSONRPC using NPM" 
showToc: true
categories:
- 
tags:
- reverse proxy 
- aria2
- npm (Nginx Proxy Manager)
- JSONRPC
ShowLastMod: true
cover:
    image: "img/npm-aria2/npm-aria2.jpg"
---


> aria2 is a **lightweight** multi-protocol & multi-source command-line **download utility**. It supports **HTTP/HTTPS**, **FTP**, **SFTP**, **BitTorrent** and **Metalink**.

> The SSL certificate used by the Aria2 server does not support port 6800, so NPM (Nginx Proxy Manager) needs to be used to provide both **HTTP(s)** and **Aria2 JSONRPC** services.



---



### Edit NPM (Nginx Proxy Manager)

`Proxy Host` >> `Advanced`

![2023-01-26_153027](/img/npm-aria2/2023-01-26_153027.png)

~~~bash
#ARIA2
    location /jsonrpc {
        proxy_pass http://10.2.2.3:6800/jsonrpc;
        proxy_redirect off;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
	#The following code supports WebSocket
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
~~~



| Parameter                      | Description                                               |
| ------------------------------ | --------------------------------------------------------- |
| `location /jsonrpc`            | RPC address is //example.com/jsonrpc                      |
| `http://10.2.2.3:6800/jsonrpc` | The full path of the host (`10.2.2.3` is host IP address) |



---



### Final Result:

![2023-01-26_153126](/img/npm-aria2/2023-01-26_153126.png)

![2023-01-26_153139](/img/npm-aria2/2023-01-26_153139.png)

> You can now connect to ARIA2 RPC via "https" and "wss" (WebSocket Secure).

---

### Reference:

- [Nginx reverse proxy Aria2 JSONRPC | Kenvix's Blog](https://kenvix.com/post/nginx-proxy-aria2/)

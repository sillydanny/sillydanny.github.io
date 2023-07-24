---
title: "ttyd: Access Your Linux Terminal via Web Browser"
date: 2023-07-24T14:35:21+08:00
draft: false
author: "King Tam"
summary: "ttyd: Access Your Linux Terminal via Web Browser" 
showToc: true
categories:
- Linux
tags:
- terminal
- ttyd
ShowLastMod: true
cover:
    image: "img/ttyd/ttyd.jpg"
---

### About

`ttyd` is a tool that allows users to access their Linux terminal through a web browser. This functionality enables convenient and remote management of Linux systems regardless of the user's location.

---

### Install TTYD

We can download the latest version of ttyd from its official GitHub page:

[Download Page ↗](https://github.com/tsl0922/ttyd/releases)

To download and install ttyd, execute the following command in your terminal:

```bash
sudo wget https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.aarch64 -O \
/usr/local/bin/ttyd && sudo chmod +x /usr/local/bin/ttyd
```

To ensure that ttyd starts automatically upon system boot, we'll create a new systemd service:

```bash
sudo bash -c 'cat > /etc/systemd/system/ttyd.service << EOF
[Unit]
Description=ttyd server

[Service]
Type=simple
ExecStart=/usr/local/bin/ttyd -p 7681 login
Restart=always

[Install]
WantedBy=multi-user.target
EOF'
```

Next, set the correct permissions for the service file:

```bash
sudo chmod 644 /etc/systemd/system/ttyd.service
```

Reload the systemd configuration to recognize our new service:

```bash
sudo systemctl daemon-reload
```

Now, start your ttyd service and enable it to run at startup:

```bash
sudo systemctl start ttyd
sudo systemctl enable ttyd
```

Once the service is running, you can access the terminal via your web browser at `http://<Your-IP-Address>:7681`.

![screenshot](/img/ttyd/screenshot.gif)


Enjoy the convenience of having your Linux terminal available in your web browser with ttyd!

---

### Related:

-[Official GitHub Page](https://github.com/tsl0922/ttyd)

---
title: "SSH Tunneling"
date: 2023-07-19T14:50:57+08:00
draft: false
author: "King Tam"
summary: "SSH Tunneling" 
showToc: true
categories:
- 
tags:
- 
- 
ShowLastMod: true
cover:
    image: "img/ssh-tunnels/ssh-tunneling.jpg"
---


### About

SSH tunneling is a method of transporting arbitrary networking data over an encrypted SSH connection. It can be used for secure communications or to bypass firewalls.


---

### Mode of Port Forwarding

- Local Port Forwarding
- Remote Port Forwarding
- Dynamic Port Forwarding

---

### SSH Useful Arguments


| Option | Description                                                  |
| ------ | ------------------------------------------------------------ |
| `-N`   | This option tells SSH not to execute a remote command after establishing the connection. Instead, it just sets up the connection and then waits for further instructions. This can be useful for setting up port forwarding or other types of connections where no remote command needs to be executed. |
| `-f`   | This option runs the SSH client in the background after authentication. This allows the user to continue using the terminal while the SSH session is running in the background. This can be useful for long-running sessions or when multiple sessions need to be established simultaneously. |


---

### Sample Scenarios

> **Note:** All diagrams from [Ivan Velichko](https://iximiuz.com/en/posts/ssh-tunnels/)



1. #### **Local Port Forwarding:**

   This is the most common type of SSH tunneling, forwarding a local port to a remote one.



~~~bash
ssh -L local_port:remote_host:remote_port user@ssh_server
~~~

#####    <span style=color:red><u>**Example01:**</u></span>

![local-port-forwarding-bastion-2000-opt](/img/ssh-tunnels/local-port-forwarding-bastion-2000-opt.png)

~~~bash
ssh -N -L 8443:10.2.2.254:8006 user@10.2.2.2
~~~


| Option                 | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| `-L`                   | Local port forwarding configuration                          |
| `8443:10.2.2.254:8006` | Forward connections to port 8443 on the local machine to port 8006 on the remote machine 10.2.2.254 |
| `user@10.2.2.2`        | Username and hostname of the remote server                   |

> **Note:** `0.0.0.0:8443:10.2.2.254:8006`, which `0.0.0.0` means listening on all available network interfaces.

![2023-07-19_103836](/img/ssh-tunnels/2023-07-19_103836.png)

The service running on port 8443 can be accessed from the server area server by localhost.



##### <span style=color:red><u>**Example02:**</u></span>

![local-port-forwarding-2000-opt](/img/ssh-tunnels/local-port-forwarding-2000-opt.png)

~~~bash
ssh -N -L 5201:localhost:5201 user@ssh_server
~~~

![2023-07-19_105519](/img/ssh-tunnels/2023-07-19_105519.png)

A port `5201' test was successfully conducted on localhost after binding the port.



---

2. #### **Remote Port Forwarding:**

   This allows you to forward a remote port to a local one.

> For security reasons, Remote Port Forwarding is only bound to the localhost of the SSH Server by default. To enable external connections, the configuration file of the SSH Server needs to be amended


~~~bash
sudo sh -c 'echo "GatewayPorts yes" >> /etc/ssh/sshd_config.d/GatewayPorts.conf'
~~~

~~~bash
sudo service sshd restart
~~~

Restart the SSH daemon for the modifications to take effect.



![remote-port-forwarding-2000-opt](/img/ssh-tunnels/remote-port-forwarding-2000-opt.png)

~~~bash
ssh -N -R remote_port:local_host:local_port user@ssh_server
~~~

##### <span style=color:red><u>**Example01:**</u></span>

~~~bash
ssh -N -R 8080:localhost:8000 user@10.2.2.2
~~~


| Option                | Description                                                  |
| --------------------- | ------------------------------------------------------------ |
| `-R`                  | Remote port forwarding configuration                         |
| `8080:localhost:8000` | Forward connections to port 8080 on the remote server to port 8000 on the local machine, binding to localhost |
| `user@10.2.2.2`       | Hostname or IP address of the remote server                  |

![2023-07-19_113526](/img/ssh-tunnels/2023-07-19_113526.png)

A simple HTTP server has been set up on localhost with port 8000.

![2023-07-19_113559](/img/ssh-tunnels/2023-07-19_113559.png)

The remote client (10.2.2.x) can access the HTTP server running on port 8080.



![remote-port-forwarding-home-network-2000-opt](/img/ssh-tunnels/remote-port-forwarding-home-network-2000-opt.png)

#####    <span style=color:red><u>**Example02:**</u></span>

~~~bash
ssh -N -R 8443:10.10.10.254:443 user@ssh_server
~~~


| Option                  | Description                                                  |
| ----------------------- | ------------------------------------------------------------ |
| `-R`                    | Remote port forwarding configuration                         |
| `8443:10.10.10.254:443` | Forward connections to port `8443` on the remote server to port `443` on the machine with IP address `10.10.10.254` |
| `user@ssh_server`       | Username and hostname of the SSH server                      |

![2023-07-19_112905](/img/ssh-tunnels/2023-07-19_112905.png)

The SSH server is forwarding traffic from port 443 on the local area PC with IP address 10.10.10.254 to port 8443 on the SSH server.

![2023-07-19_112918](/img/ssh-tunnels/2023-07-19_112918.png)

The service on port 8443 can be accessed from the server area PC.

---

3. #### **Dynamic Port Forwarding:**

   This can be used to create a SOCKS proxy which can be used with applications configured to use SOCKS.

~~~bash
ssh -D local_port user@ssh_server
~~~

#####    <span style=color:red><u>**Example01:**</u></span>

~~~bash
ssh -N -D 8244 user@ssh_server
~~~


| Option            | Description                             |
| ----------------- | --------------------------------------- |
| `-D`              | Local SOCKS proxy port configuration    |
| `8244`            | Local SOCKS proxy port to use           |
| `user@ssh_server` | Username and hostname of the SSH server |

i. The method of routing browser traffic through a SOCKS5 proxy using a plug-in(SwitchyOmega).

![2023-07-18_133142](/img/ssh-tunnels/2023-07-18_133142.png)

![2023-07-18_133219](/img/ssh-tunnels/2023-07-18_133219.png)


ii. The method of Linux terminal traffic through socks5 proxy

~~~bash
export http_proxy=socks5://127.0.0.1:8244
export https_proxy=socks5://127.0.0.1:8244
~~~

This tells applications that use the HTTP(s) protocol to use the specified SOCKS5 proxy server for their connections.

~~~bash
export ALL_PROXY=socks5://127.0.0.1:8244
~~~

This tells all applications to use the specified SOCKS5 proxy server for their connections, regardless of the protocol.

---

### Conclusion

SSH tunneling provides a powerful and flexible way to securely transfer data over an unsecured network. By using SSH tunneling, we can access remote resources securely and efficiently, without having to worry about eavesdropping or other security threats.

---

### Reference

-[A Visual Guide to SSH Tunnels: Local and Remote Port Forwarding](https://iximiuz.com/en/posts/ssh-tunnels/)

-[SSH Tunnel 通道打造加密 Proxy，透過外部 Linux 伺服器上網](https://blog.gtwang.org/linux/ssh-tunnel-socks-proxy-forwarding-tutorial/)

-[SSH Tunneling (Port Forwarding) 詳解](https://johnliu55.tw/ssh-tunnel.html)

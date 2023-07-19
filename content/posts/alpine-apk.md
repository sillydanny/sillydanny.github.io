---
title: "Alpine Linux Package Management Tool"
date: 2023-05-24T09:12:41+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- apk
cover:
    image: "img/alpine-apk/alpine-apk.jpg"
---




### About

> The package management tool used in Alpine Linux is apk. apk is a fast, lightweight, and efficient package management tool that has the following features:

- Native support for cross-compilation and cross-platform installation.
- Automatic handling of dependencies when installing and uninstalling packages.
- Support for multiple repositories, including official repositories, community repositories, and personal repositories.
- Simple command-line interface that allows users to perform various operations such as search, install, upgrade, and uninstall.
- Support for virtual packages that enables users to install a set of related packages by installing a single virtual package.

---


### How to Use

Here are some basic commands for using the `apk` package manager in Alpine Linux:

-Update the package index:

```
apk update
```

-Search for a package:

```
apk search <package_name>
```

-Install a package:

```
apk add <package_name>
```

-Remove a package:

```
apk del <package_name>
```

-View information about a package:

```
apk info <package_name>
```

-List all installed packages:

```
apk info -vv | less
```

-Upgrade all installed packages:

```
apk upgrade
```

-Upgrade a specific package:

```
apk upgrade <package_name>
```

-List the contents of a package:

```
apk info -L <package_name>
```

-Show the dependencies of a package:

```
apk info -R <package_name>
```

---

### Enable community repositories

Edit the file `/etc/apk/repositories` and uncomment a line that points to the "community" directory.

![2023-03-26_123724.png](/img/alpine-apk/2023-03-26_123724.png)

![2023-03-26_124102.png](/img/alpine-apk/2023-03-26_124102.png)

---


### Using Examples

To install `neovim` in Alpine Linux using the apk

~~~bash
apk add neovim
~~~

> (1/11) Installing libintl (0.21.1-r1)
> (2/11) Installing libgcc (12.2.1_git20220924-r4)
> (3/11) Installing luajit (2.1_p20210510-r3)
> (4/11) Installing libuv (1.44.2-r0)
> (5/11) Installing libluv (1.44.2.1-r0)
> (6/11) Installing msgpack-c (4.0.0-r0)
> (7/11) Installing unibilium (2.1.1-r0)
> (8/11) Installing libtermkey (0.22-r0)
> (9/11) Installing tree-sitter (0.20.7-r0)
> (10/11) Installing libvterm (0.3-r0)
> (11/11) Installing neovim (0.8.1-r0)
> Executing busybox-1.35.0-r29.trigger
> OK: 138 MiB in 71 packages

To install multiple applications with apk in Alpine Linux

~~~bash
apk add bash bash-doc bash-completion
~~~

> (1/7) Installing readline (8.2.0-r0)
> (2/7) Installing bash (5.2.15-r0)
> Executing bash-5.2.15-r0.post-install
> (3/7) Installing pkgconf (1.9.4-r0)
> (4/7) Installing bash-completion (2.11-r4)
> (5/7) Installing openrc-bash-completion (0.45.2-r7)
> (6/7) Installing bash-doc (5.2.15-r0)
> (7/7) Installing kmod-bash-completion (30-r1)
> Executing busybox-1.35.0-r29.trigger
> OK: 145 MiB in 78 packages

The "apk search" command in Alpine Linux

~~~bash
apk search docker
~~~

> This will display a list of packages related to Docker.

To uninstall or remove an application in Alpine Linux using apk

List all installed packages and find out the application as you want to remove.

~~~bash
apk list | grep 'neovim'
~~~

Use the "apk del" command followed by the name of the package to remove it

~~~bash
apk del neovim
~~~

> (1/11) Purging neovim (0.8.1-r0)
> (2/11) Purging libintl (0.21.1-r1)
> (3/11) Purging luajit (2.1_p20210510-r3)
> (4/11) Purging libgcc (12.2.1_git20220924-r4)
> (5/11) Purging libluv (1.44.2.1-r0)
> (6/11) Purging libuv (1.44.2-r0)
> (7/11) Purging msgpack-c (4.0.0-r0)
> (8/11) Purging libtermkey (0.22-r0)
> (9/11) Purging unibilium (2.1.1-r0)
> (10/11) Purging tree-sitter (0.20.7-r0)
> (11/11) Purging libvterm (0.3-r0)
> Executing busybox-1.35.0-r29.trigger
> OK: 123 MiB in 67 packages

---


### Overall

> `apk` is a fast, lightweight, and efficient package management tool that makes it easy for users to manage and maintain software packages in Alpine Linux.

---


### Related

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)
- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)
- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)
- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)

  [1]: https://kingtam.win/usr/uploads/2023/05/3815067954.png
  [2]: https://kingtam.win/usr/uploads/2023/03/1739197784.png
  [3]: https://kingtam.win/usr/uploads/2023/03/1425442628.png

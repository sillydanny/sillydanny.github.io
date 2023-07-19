---
title: "Alpine Linux Customizations"
date: 2023-05-24T11:03:51+08:00
draft: false
author: "King Tam"
showToc: true
categories:
- Linux
tags:
- alpine
- bash
- MOTD
- SSH
- neovim
- useradd
cover:
    image: "img/alpine-custom/alpine-custom.jpg"
---




> One of the benefits of using Alpine Linux is its flexibility and customizability, which allows users to tailor the system to their specific needs.

---



<span id="date"></span>


### Setting the timezone


Check the current timezone

~~~bash
date
~~~

Timezone setting

~~~bash
setup-timezone
~~~

Which timezone are you in? ('?' for list) [UTC] `Asia/Hong_Kong`

> Suppose you want to use the `Asia/` timezone and `Hong_Kong` as the sub-timezone of 'Asia/'. You can input '?' to list the timezones to choose from.

Check the Date

~~~bash
date
~~~

---

<span id="motd"></span>


### Make a dynamic MOTD

> MOTD stands for "Message of the Day" in Linux. It is a customizable message that is displayed to users when they log in to the system. 

Create a `crond script` to dynamic create an `motd` message to users

~~~bash
rc-service crond start && rc-update add crond
vi /etc/periodic/15min/motd
chmod a+x /etc/periodic/15min/motd
run-parts --test /etc/periodic/15min
~~~

| Command                                | Description                                                  |
| -------------------------------------- | ------------------------------------------------------------ |
| `rc-service crond start`               | Starts the `crond` service, which runs scheduled tasks on the system. |
| `rc-update add crond`                  | Adds the `crond` service to the default runlevel, ensuring that it starts automatically on boot. |
| `vi /etc/periodic/15min/motd`          | Use the Vi text editor and creates a new shell script at `/etc/periodic/15min/motd`. This script is executed every 15 minutes to update the MOTD. |
| `chmod a+x /etc/periodic/15min/motd`   | Sets the execute permission for the `motd` script, allowing the system to run it as a periodic task. |
| `run-parts --test /etc/periodic/15min` | Tests the `/etc/periodic/15min` directory for executable scripts and prints a list of the scripts that would be executed by the system's periodic task scheduler. |



Contents of `/etc/periodic/15min/motd`

~~~bash
#!/bin/sh
#. /etc/os-release
PRETTY_NAME=`awk -F= '$1=="PRETTY_NAME" { print $2 ;}' /etc/os-release | tr -d '"'`
VERSION_ID=`awk -F= '$1=="VERSION_ID" { print $2 ;}' /etc/os-release`
UPTIME_DAYS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 / 86400)
UPTIME_HOURS=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 / 3600)
UPTIME_MINUTES=$(expr `cat /proc/uptime | cut -d '.' -f1` % 31556926 % 86400 % 3600 / 60)
cat > /etc/motd << EOF
%+++++++++++++++++++++++++++++++ SERVER INFO ++++++++++++++++++++++++++++++++%
%                                                                            %
        Name: `hostname`
        Uptime: $UPTIME_DAYS days, $UPTIME_HOURS hours, $UPTIME_MINUTES minutes
        CPU: `cat /proc/cpuinfo | grep 'model name' | head  -1 | cut -d':' -f2`
        Memory: `free -m | head -n 2 | tail -n 1 | awk {'print  $2'}`M
        Swap: `free -m | tail -n 1 | awk {'print $2'}`M Disk: `df -h / | awk  '{ a = $2 } END { print a }'`

        Kernel: `uname -r`
        Distro: $PRETTY_NAME
        Version $VERSION_ID
    
        CPU Load: `cat /proc/loadavg | awk '{print $1 ", " $2 ", " $3}'`
        Free Memory: `free -m | head -n 2 | tail -n 1 | awk {'print $4'}`M
        Free Swap: `free -m | tail -n 1 | awk {'print $4'}`M
        Free Disk: `df -h / | awk '{ a =  $2 } END { print a }'`
    
        eth0 Address: `ifconfig eth0 | grep "inet addr" |  awk -F: '{print $2}' | awk '{print $1}'`

%                                                                            %
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++%
EOF
~~~



This is the result:

![2023-03-30_101349.png](/img/alpine-custom/2023-03-30_101349.png)



---

<span id="shell"></span>


### Changing To The Bash Shell

> Bash is a popular command shell in the Linux community, and many users prefer it over the default shell in Alpine Linux, which is ash. Changing to the Bash shell in Alpine Linux is a simple process that can greatly enhance our productivity and efficiency when working with the Linux system.

Alpine Linux uses Ash by default as the shell, but I prefer to use Bash as my Linux shell. To install Bash in Alpine Linux and make it the default shell, follow these steps:

Install Bash:

```bash
apk add bash bash-doc bash-completion
```

Change the default shell for your user:

```bash
sed -i 's/ash/bash/' /etc/passwd
```

Verify the change by checking the first line of the `/etc/passwd` file:

```bash
cat /etc/passwd | head -n 1
```

It should display `/bin/bash`.

Customize the Bash shell. We can configure the Bash shell liking by adding your aliases and settings. 
   Here is an example of customization:

```bash
cat >> ~/.bash_profile << EOF
alias update='apk update && apk upgrade'
export HISTTIMEFORMAT="%d/%m/%y %T "
export PS1='\u@\h:\W \$ '
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alhF'
alias ls='ls --color=auto'
source /etc/profile.d/bash_completion.sh
export PS1="\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\W\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "
EOF
```

This customizes the Bash shell with aliases for common commands, a colored prompt, and auto-completion using the `bash_completion.sh` script.

---



<span id="neovim"></span>


### NeoVim and Vim plugins Install in Alpine Linux

> NeoVim is a popular text editor that is designed to be more extensible and customizable than traditional editors like Vim. It offers many features that make it an excellent choice for developers and testers.

To install NeoVim and Vim plugins in Alpine Linux, follow these steps:

Install NeoVim using the apk package manager:

```bash
apk add neovim curl git
```

Install Vim plugins using the Vim plugin manager, such as Vim-Plug. First, download and install Vim-Plug:

```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Create the NeoVim configuration file:

```bash
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
```

Add the following lines to your init.vim file to set up Vim-Plug and install plugins:

```vim
call plug#begin('~/.local/share/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
call plug#end()
```

Save and exit the init.vim file.

Open NeoVim:

```bash
nvim
```

Install the Vim plugins using the following command:

```bash
:PlugInstall
```

This will download and install the plugins specified in your init.vim file.



---


<span id="user"></span>


### Setting up a new user

> Installing sudo and assigning sudo privileges to a new user in Alpine Linux can greatly enhance your system's security and flexibility.

Install sudo using the apk package manager:

```bash
apk add sudo
```

> (1/1) Installing sudo (1.9.12_p2-r1)
> Executing busybox-1.35.0-r29.trigger

Create a new user:

~~~bash
NEWUSER='user'
~~~

> 'user' as your UserName

~~~bash
adduser -g "${NEWUSER}" $NEWUSER -s /bin/bash
~~~

> Changing password for user
> New password:
> Bad password: too weak
> Retype password:
> passwd: password for user changed by root

> also the new user using a bash shell as default shell and 

Add the new user to the sudo group:

```bash
echo "$NEWUSER ALL=(ALL) ALL" > /etc/sudoers.d/$NEWUSER && chmod 0440 /etc/sudoers.d/$NEWUSER
```

> create a username file in the sudoers folder to allow the new user to use sudo:

Once you have completed these steps, the new user can use the sudo command to elevate their privileges when necessary. 
To use the sudo command, the user should prefix the command they want to run with "sudo", like this:

```bash
sudo apk update
```

For example, if the new user wants to install a new package using apk, they can use the following command:

```bash
sudo apk add <package_name>
```

This will prompt the user to enter their password before allowing the command to run with elevated privileges.



---



<span id="ssh"></span>


### SSH key authentication to login

Update the package and Install OpenSSH:

   ````
   apk update && apk add openssh
```

Once the installation is complete, start the OpenSSH service:

   ````
   /etc/init.d/sshd start
```

Enable the service to start automatically at boot:

   ````
   rc-update add sshd
```


> Using SSH key authentication to log in to Alpine Linux without a password is a secure and convenient way to access your system remotely.

To use SSH key authentication to login to Alpine Linux without a password, follow these steps:




### Local server setting (as a client)

Generate an SSH key pair on your local machine if you haven't already done so:

```bash
ssh-keygen
```

Copy the public key to the remote server (Alpine Linux) using the ssh-copy-id command:


```bash
ssh-copy-id <username>@<server_ip_address>
```

Enter your user password when prompted.


SSH into the remote server:

```bash
ssh <username>@<server_ip_address>
```

You should now be able to log in to the remote server without being prompted for your password.




### Remote server setting (as server)

Disabling Password Authentication on your Server

~~~bash
sudo -i
~~~

~~~bash
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
~~~

~~~bash
rc-service sshd restart
~~~

>  * Caching service dependencies ...                                                                               [ ok ]
>  * Stopping sshd ...                                                                                              [ ok ]
>  * Starting sshd ...                                                                                              [ ok ]


---



<span id="ping"></span>


### Enable unprivileged users to use ICMP (Ping)

> To fix the error "unprivileged ping is disabled, please enable by setting net.ipv4.ping_group_range" when trying to use the ping command, 
> it means that non-root users are not allowed to use the ping command.

Add a new config file:

```
echo 'net.ipv4.ping_group_range = 0 65534' >> /etc/sysctl.d/99-allow-ping.conf
```

Apply the changes:

```
sysctl -p
```


---


### Conclusion

> Alpine Linux is a highly customizable distribution of Linux that offers a wide range of customizations to enhance your experience with the system. 
> By following the customizations outlined in this post, We can tailor Alpine Linux to our specific needs and preferences, making it a powerful and flexible tool for development and system administration.

---


### Reference

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [How to install bash shell in Alpine Linux](https://www.cyberciti.biz/faq/alpine-linux-install-bash-using-apk-command/)
- [Setting up a new user](https://wiki.alpinelinux.org/wiki/Setting_up_a_new_user)
- [How To Configure SSH Key-Based Authentication on a Linux Server](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)

---


### Related

- [Alpine Linux Installation](https://kingtam.win/archives/alpine-install.html)
- [Apline Linux's Package Management Tool](https://kingtam.win/archives/alpine-apk.html)
- [Alpine Linux customizations](https://kingtam.win/archives/apline-custom.html)
- [Alpine Linux-based LXC with Docker support on a PVE host](https://kingtam.win/archives/alpine-docker.html)
- [Alpine Linux as a DHCP and DNS Server](https://kingtam.win/archives/alpine-dhcp-dns.html)
- [Alpine Linux share the terminal over the web (ttyd)](https://kingtam.win/archives/alpine-ttyd.html)
- [Set up SmartDNS in Alpine Linux (LXC)](https://kingtam.win/archives/smartdns.html)


---
title: "Synology DSM Customization: Unlocking the Potential of NAS"
date: 2023-06-21T09:05:18+08:00
draft: false
author: "King Tam"
summary: "Synology DSM Customization: Unlocking the Potential of NAS" 
showToc: true
categories:
- Linux
tags:
- Synology
- dsm
- Entware
- vim
- opkg
- sudo
- docker
ShowLastMod: true
cover:
    image: "img/dsm-custom/dsm-custom.jpg"
---

[image from unsplash](https://images.unsplash.com/photo-1627135190425-754d8d5ef117?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80)

---

### About

> As you know, Synology NAS devices are based on the Linux kernel, but they have some function limitations that make installing applications not as easy as using package management systems like `apt`, `yum`, or `dnf`. Also, commands like `usermod` and `groupadd` don't actually exist on Synology NAS.

---

### Sudo without Password (Option)

1. Eable SSH on Synology

![2023-06-21_090947](/img/dsm-custom/2023-06-21_090947.png)

2. Remove the need to enter a password each time `sudo` is used.

> Log in to Synology DSM using `ssh` with an account that has `sudo` permissions.

~~~bash
sudo tee /etc/sudoers.d/$(USER) <<<  '$(USER) ALL=(ALL) NOPASSWD: ALL'
~~~

> $(USER) is the current username, which is up to you.

3. Update the permission to read-only.

~~~bash
sudo chmod 400 /etc/sudoers.d/$(USER)
~~~

---

### Install Entware on Synology DSM

> Entware has been adapted for Synology's DSM as a software repository.

1. Create a folder on your HDD

```bash
mkdir -p /volume1/@Entware/opt
```



2. Remove `/opt` and mount the Optware folder.

> Make sure that the `/opt` folder is empty (Optware is not installed). Remove the `/opt` folder with its contents in this step.

```bash
rm -rf /opt
mkdir /opt
mount -o bind "/volume1/@Entware/opt" /opt
```

**Note**: If the `bind` command doesn't work, try creating a link instead:

```bash
ln -s /volume1/@Entware/opt/ /opt
```



3. Run the installation script depending on the processor (`uname -m` to know).

for armv8 (aarch64) - Realtek RTD129x

```bash
wget -O - https://bin.entware.net/aarch64-k3.10/installer/generic.sh | /bin/sh
```

for armv5

```bash
wget -O - https://bin.entware.net/armv5sf-k3.2/installer/generic.sh | /bin/sh

```

for armv7

```bash
wget -O - https://bin.entware.net/armv7sf-k3.2/installer/generic.sh | /bin/sh
```

for x64

```bash
wget -O - https://bin.entware.net/x64-k3.2/installer/generic.sh | /bin/sh
```



4. Create Autostart Task

Create a triggered user-defined task in Task Scheduler.

> Goto: DSM > Control Panel > Task Scheduler
> Create > Triggered Task > User Defined Script
> General
> Task: Entware
> User: root
> Event: Boot-up
> Pretask: none
> Task Settings
> Run Command: (as bellow)

~~~bash
#!/bin/sh

# Mount/Start Entware
mkdir -p /opt
mount -o bind "/volume1/@Entware/opt" /opt
/opt/etc/init.d/rc.unslung start

# Add Entware Profile in Global Profile
if grep  -qF  '/opt/etc/profile' /etc/profile; then
	echo "Confirmed: Entware Profile in Global Profile"
else
	echo "Adding: Entware Profile in Global Profile"
cat >> /etc/profile <<"EOF"

# Load Entware Profile
[ -r "/opt/etc/profile" ] && . /opt/etc/profile
EOF
fi

# Update Entware List
/opt/bin/opkg update
~~~

5.  Reboot your NAS.

---

### Install Packages

Install all the packages through `opkg`

~~~bash
sudo opkg install git git-http wget curl tree iperf3
~~~

> This installs Git, Git over HTTP, wget, curl, tree, and iperf3 packages using the `opkg` package manager with superuser privileges.

---

### Manage Docker Without Using Sudo

> Manage Docker on Synology NAS via `ssh` without requiring `sudo`.

1. Create a new user group called `docker`.

~~~bash
sudo synogroup --add docker
~~~

2. Add the user you want to use to this group

~~~bash
sudo synogroup --member docker $USER
~~~

3. Change the ownership of the `docker.sock` file.

~~~bash
sudo chown root:docker /var/run/docker.sock 
~~~

Once have completed these steps, log out and back in again to ensure the changes take effect.

---

### Install VIM-PLUG on Synology DSM

1. Download `plug.vim` and put it in the "autoload" directory.

~~~bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
~~~

2. Add a vim-plug section to your `~/.vimrc`.

~~~bash
cat >> ~/.vimrc << EOF
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keyboard mapping to toggle the nerdtree file explorer.

nnoremap <F5> :exec 'NERDTreeToggle' <CR>

" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set colorscheme
set background=dark

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Enable status bar color
set t_Co=256

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Airline themes
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" Vim Cpp Highlight
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_experimental_simple_template_highlight=1
let g:cpp_concepts_highlight=1
EOF
~~~

3. Reload `.vimrc` and install plugins.

> Open vi editor

~~~bash
:PlugInstall
~~~

### Commands

| Command                             | Description                                                  |
| ----------------------------------- | ------------------------------------------------------------ |
| `PlugInstall [name ...] [#threads]` | Install plugins                                              |
| `PlugUpdate [name ...] [#threads]`  | Install or update plugins                                    |
| `PlugClean[!]`                      | Remove unlisted plugins (bang version will clean without prompt) |
| `PlugUpgrade`                       | Upgrade vim-plug itself                                      |
| `PlugStatus`                        | Check the status of plugins                                  |
| `PlugDiff`                          | Examine changes from the previous update and the pending changes |
| `PlugSnapshot[!] [output path]`     | Generate script for restoring the current snapshot of the plugins |

---

### Conclusion

> `Entware`, managing Docker without requiring `sudo`, and installing packages using `opkg`. This is a useful for users looking to customize on Synology NAS devices.

---

### Reference

- [Install on Synology NAS](https://github.com/Entware/Entware/wiki/Install-on-Synology-NAS)
- [Manage docker without needing sudo on your Synology NAS](https://davejansen.com/manage-docker-without-needing-sudo-on-your-synology-nas/)
- [VIM-PLUG](https://github.com/junegunn/vim-plug)

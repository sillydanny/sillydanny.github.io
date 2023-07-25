---
title: "Secure Linux Login Connection"
date: 2023-07-25T16:47:52+08:00
draft: false
author: "King Tam"
summary: "Secure Linux Login Connection" 
showToc: true
categories:
- Linux
tags:
- SSH
- ssh-keygen
ShowLastMod: true
cover:
    image: "img/ssh-key/ssh-key.jpg"
---


## Introduction

SSH offers two methods of authentication: password and key pair authentication.

- Password Authentication: While simple passwords are easily remembered, they are also easily compromised through brute force attacks. On the other hand, complex passwords, though safer, are challenging to remember.

- Key Pair Authentication: This method involves a combination of a public key and a private key. The public key is placed on the device that one wishes to access, while the private key is stored on the user's local machine. Only the holder of the private key can access the device, making this method secure and convenient.

## Generating a Key Pair with `ssh-keygen`

The `ssh-keygen` command can be used to generate a key pair. Here is how to use it:

```bash
ssh-keygen
```

For a stronger key pair, use:

```bash
ssh-keygen -t rsa -b 4096 -C $comment
```

> Note: When prompted, hit Enter for each prompt.

## Uploading the Public Key to the Remote Host

There are two ways to upload the public key: manually and automatically.

### Automatic Upload

To automatically upload the public key, run:

```bash
ssh-copy-id user@remoteHost
```

Or specify the public key and port:

```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remoteHost
```

### Manual Upload

To manually upload the public key, copy the public key content:

```bash
ssh user@remoteHost 'mkdir -p .ssh && cat >> .ssh/authorized_keys' < ~/.ssh/id_rsa.pub
```

Next, set the correct permissions on the remote host:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

After creating the `authorized_keys` file and pasting the public key contents into it, we can log in without a password:

```bash
ssh user@remoteHost
```

## Managing Sessions via SSH Profiles

SSH profiles are an elegant and efficient way to manage multiple remote logins. You can create several remote hosts on the SSH profiles as shown:

```bash
cat >> ~/.ssh/config << EOF
Host HOST01
    HostName 123.123.123.33
    Port 22
    User user01
    IdentityFile "~/.ssh/id_rsa"
    IdentitiesOnly yes

Host HOST02
    HostName 10.110.254.99
    Port 2222
    User user02
    IdentityFile "~/.ssh/id_ecdsa"
    IdentitiesOnly yes
EOF
```

Ensure that you set the correct permissions on the SSH profiles:

```bash
chmod 600 ~/.ssh/config
```

After setting up the SSH profiles, you can log in by simply entering the alias name:

```bash
ssh HOST01
```

## Disabling Password Login

For security reasons, it is recommended to disable password login:

```bash
sudo sed -i "s@.*\(PasswordAuthentication \).*@\1no@" /etc/ssh/sshd_config
sudo service sshd restart
```

## One-Key Configuration on SSH

Setting up a new remote host key login requires several steps such as key pair generation, permissions setting, public key upload, and password disabling.

However, we can upload all the public keys to [Github SSH keys](https://github.com/settings/keys), and then deploy the public key with one command on the new remote host:

```bash
curl -fsSL https://github.com/$githubUser.keys >> ~/.ssh/authorized_keys
```

Also, disable the password and restart the SSH daemon:

```bash
sudo sed -i "s@.*\(PasswordAuthentication \).*@\1no@" /etc/ssh/sshd_config
sudo service sshd restart
```

---

Additionally, we can simplify the process using [P3TERX's SSH Key Installer](https://github.com/P3TERX/SSH_Key_Installer):

```bash
bash <(curl -fsSL git.io/key.sh) -g $githubUser -d
```

| Option | Description                                                  |
| :----- | :----------------------------------------------------------- |
| -o     | Enables overwrite mode. Must be written at the top to take effect. |
| -g     | Retrieves the public key from GitHub. The parameter is the GitHub username. |
| -u     | Retrieves the public key from a URL. The parameter is the URL. |
| -f     | Obtains the public key from a local file. The parameter is the path of the local file. |
| -p     | Modifies the SSH port. The parameter is the port number.     |
| -d     | Disables password login.                                     |



### Deploying the Public Key

Here are some ways of getting the public key:

i. Get the public key from [Github](https://github.com/settings/keys):

```bash
bash <(curl -fsSL git.io/key.sh) -g $githubUser
```

ii. Get the public key from a URL:

```bash
bash <(curl -fsSL git.io/key.sh) -u https://keyaddress.com/id_rsa.pub
```

iii. Overwrite mode will completely replace the previous key on `/.ssh/authorized_keys`:

```bash
bash <(curl -fsSL git.io/key.sh) -o -g $githubUser
```

iv. Disable password login:

```bash
bash <(bash <(curl -fsSL git.io/key.sh) -d
```

v. Modify the SSH port:

```bash
bash <(curl -fsSL git.io/key.sh) -p 2222
```



---



## Conclusion

Whether manually or automatically, managing SSH keys involves creating a secure key pair, uploading the public key to the intended device, and managing sessions using SSH profiles. For increased security, it is advisable to disable password logins. Various tools such as P3TERX's SSH Key Installer can simplify these processes.



---

## Reference

- [使用 ssh-keygen 和 ssh-copy-id 組態 SSH 金鑰實現免密登陸](https://p3terx.com/archives/configuring-ssh-keys-with-sshkeygen-and-sshcopyid.html)
- [SSH 金鑰一鍵組態指令碼 使用教學](https://p3terx.com/archives/ssh-key-installer.html)


---

## Related:

- [SSH Tunneling](https://kingtam.eu.org/posts/ssh-tunneling/)



---
title: "Securely Transfer Files Over The Network"
date: 2023-07-21T10:12:20+08:00
draft: false
author: "King Tam"
summary: "Securely Transfer Files Over The Network" 
showToc: true
categories:
- Linux
tags:
- ssh
- sftp
- scp
- tar
ShowLastMod: true
cover:
    image: "img/sftp-scp/sftp-scp.jpg"
---


### Secure File Transfer Protocol (SFTP)

SFTP, or Secure File Transfer Protocol, is a network protocol that provides file access, file transfer, and file management functionalities over any reliable data stream. It is typically used with the SSH protocol to provide secure file transfer, but it can be used with other protocols as well.

Use SFTP:

~~~bash
sftp username@remote-host
~~~

This command will initiate an SFTP session with the `remote-host`. It will be prompted to enter the password for the `username` connecting with.

Once in the SFTP session, we can use `ls` to list files, `cd` to change directories, `get` to download files, and `put` to upload files. Here are syntax for reference:

| Server Actions           | Command Syntax                                            |
| ------------------------ | --------------------------------------------------------- |
| Change directory         | `cd /etc/test` or `cd PATH`                               |
| List files               | `ls dir`                                                  |
| Create directory         | `mkdir directory`                                         |
| Delete directory         | `rmdir directory`                                         |
| Show current directory   | `pwd`                                                     |
| Change group             | `chgrp groupname PATH`                                    |
| Change owner             | `chown username PATH`                                     |
| Change permissions       | `chmod 644 PATH` (where 644 is an example of permissions) |
| Create link              | `ln oldname newname`                                      |
| Delete file or directory | `rm PATH`                                                 |
| Rename file or directory | `rename oldname newname`                                  |
| Exit server              | `exit`, `bye`, or `quit`                                  |

| Client Actions               | Command Syntax                                               |
| ---------------------------- | ------------------------------------------------------------ |
| Change local directory       | `lcd PATH`                                                   |
| List local files             | `lls`                                                        |
| Create local directory       | `lmkdir directory`                                           |
| Show current local directory | `lpwd`                                                       |
| Upload file to server        | `put [local directory or file] [remote]`                     |
| Download file from server    | `get [remote host directory or file] [local machine]`        |
| Wildcards supported          | Use `*` or `*.rpm` in file names for uploading/downloading multiple files |





---



### Secure Copy Protocol (SCP)

Secure Copy Protocol (SCP) is a means of securely transferring computer files between a local and a remote host or between two remote hosts. It uses SSH for data transfer and provides the same authentication and security as SSH.



i. (`push` file) The example of using SCP to transfer files:

~~~bash
scp "/path/to/localFile" username@remote-host:/path/to/remoteDirectory
~~~

This command will copy the file `localFile` from local machine to the `remoteDirectory` on the `remote-host`.



ii. (`push` directory) The example of using SCP to transfer directory, the `-r` (recursive) option is require:

~~~bash
scp -r /path/to/localDirectory username@remote-host:/path/to/remoteDirectory
~~~



iii. (`pull` file) To copy a file from the remote host to local machine:

~~~bash
scp username@remote-host:/path/to/remoteFile /path/to/localDirectory
~~~



| Option     | Description                                                  |
| ---------- | ------------------------------------------------------------ |
| `-p`       | Preserves the original file's permissions and metadata.      |
| `-r`       | Recursively copies directories and their contents.           |
| `-l speed` | Limits the transfer speed to the specified rate in Kbps. For example, `-l 800` limits the speed to 100 KB/s. |





---

### Transfer files via TAR on SSH

TAR over SSH provides end-to-end encryption, which means that the contents of the transferred files are protected from unauthorized access. It also allows you to transfer multiple files or directories in a single archive, which can be more efficient than transferring them individually.



```bash
tar czf - /path/to/directory | ssh user@remotehost "tar xzf - -C /remote/path"
```



This command will create a compressed tarball of the directory located at `/path/to/directory`, and then pipe the output to the `ssh` command, which will connect to the remote host as `user` and extract the contents of the tarball to the directory located at `/remote/path`.



| Actions                                  | Command Syntax                 |
| ---------------------------------------- | ------------------------------ |
| Create compressed tarball of a directory | `tar czf - /path/to/directory` |
| Pipe output to SSH command               | `|`                            |
| Connect to remote host                   | `ssh user@remotehost`          |
| Extract tarball to specify directory     | `tar xzf - -C /remote/path`    |
| `c`: Create new archive                  | `tar c`                        |
| `z`: Compress with gzip                  | `tar z`                        |
| `f`: Write archive to file               | `tar f`                        |
| `-`: Output to stdout instead of file    | `tar -`                        |
| `x`: Extract files from archive          | `tar x`                        |



---

### Conclusion

These are the fundamentals of using `sftp`, `scp`, and `tar` on Linux. They are robust tools that, once mastered, can greatly aid in managing and transferring files between systems.



---

### Reference

- [ssh 用戶端連線程式 - Linux 用戶](https://linux.vbird.org/linux_server/centos6/0310telnetssh.php#ssh_start)

---

### Related

- [RSYNC USAGE](https://kingtam.eu.org/posts/rsync-usage/)
- [Synchronization Solution on Windows (RSYNC)](https://kingtam.eu.org/posts/rsync-windows/)

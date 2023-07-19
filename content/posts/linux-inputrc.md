---
title: "Linux Terminal Tab Completion"
date: 2023-06-09T15:01:00+08:00
draft: false
author: "King Tam"
summary: "Tab completion is a feature in the Linux terminal that allows you to quickly complete file and directory names"
showToc: true
categories:
- Linux
tags:
- inputrc
ShowLastMod: true
cover:
    image: "img/linux-inputrc/linux-inputrc.jpg"
---

# Linux Terminal Tab Completion

---

### About:

> Tab completion is a feature in the Linux terminal that allows you to quickly complete file and directory names, command names, and other items by pressing the "Tab" key.

---

### Steps of Config:

> Tab completion can be customized and extended by modifying the `.inputrc` file

#### Create an ".inputrc" file in the user's home directory.

```bash
touch .inputrc
```

#### Case-sensitive auto-completion

```bash
vim .inputrc
```

Enter `set completion-ignore-case on`

`:wq` save and exit

#### Display all possible choices

```bash
vim .inputrc
```

Enter `set show-all-if-ambiguous on`

`:wq` save and exit

---

### Using the Alternative Config

 > In fact, this command can be used to do it all.

```bash
cat >> ".inputrc" << EOF
set completion-ignore-case on
set show-all-if-ambiguous on
EOF
```

#### Close the terminal and reopen the terminal.

---

### Conclusion:

> Tab completion can also be used with options and arguments of commands.  For example, you can type "ls -" and then press "Tab" to see a list of  available options for the "ls" command.

---

### Related:

- [Linux 的命令基本用法 - vim 編輯器](https://kingtam.win/archives/vim.html)
- [Set Git-Bash as Default Shell in Windows Terminal](https://kingtam.eu.org/posts/windows-git/)
- [Linux Terminal Tab Completion](https://kingtam.eu.org/posts/linux-inputrc/)
- [Alpine Linux Customizations](https://kingtam.eu.org/posts/alpine-customization/)

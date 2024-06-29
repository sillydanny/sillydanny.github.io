---
title: "Unleashing the Power of vim-commentary Plug-in"
date: 2023-12-03T16:32:26+08:00
draft: false
author: "King Tam"
summary: "The incredible vim-commentary plug-in developed by [tpope]" 
showToc: true
categories:
- Linux
tags:
- vim-commentary
- Plug-in
- vim
ShowLastMod: true
cover:
    image: "img/vim-commentary/Cover.jpeg"
---

### Introduction:

The incredible vim-commentary plug-in developed by [tpope](https://github.com/tpope). 

As someone who doesn't use vim frequently, I often forget to take advantage of its features. This post serves as a handy memo to remind myself (and others) about the usefulness of this plug-in.

---

### The Basic Concept of Modes in Vim:

Before we delve into the practical usage of the vim-commentary plug-in, it's essential to grasp the concept of modes in Vim. Vim operates in three primary modes that determine how we interact with the text:

| Mode         | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| Normal       | Default; for navigation and delete or duplicate, etc.        |
| Insert       | For edit text                                                |
| Command Line | For operations like saving, exiting, or work with plug-in, etc. |

---

### Use the vim-commentary Plug-in:

> The different ways to utilize the vim-commentary plug-in in each mode.

### Normal Mode:

1. #### `gcc`: 

   In normal mode, entering "`gcc`" comments or uncomments a single line. Repeating the command will toggle the comment status.

   ![2023-12-03_121111](/img/vim-commentary/2023-12-03_121111.png)

   comments 

   ![2023-12-03_121121](/img/vim-commentary/2023-12-03_121121.png)

   uncomments 

   

   The vim-commentary plug-in also allows us to comment multiple lines at once. 

   By using the command "`gc`" followed by a `digit number` and the up or down arrow keys (`j`/`k`), we can effortlessly comment or uncomment as many lines as we want.

    e.g. `gc`+`3`+`j`

   ![2023-12-03_160908](/img/vim-commentary/2023-12-03_160908.png)

   comments 

   ![2023-12-03_160916](/img/vim-commentary/2023-12-03_160916.png)

   uncomments 

2. #### `gc` + `j`/`k`:

   Using "`gc`" followed by the up or down arrow keys (`j` or `k`) allows us to comment or uncomment two lines simultaneously, with the indicator adjusting accordingly.

   ![2023-12-03_121304](/img/vim-commentary/2023-12-03_121304.png)

   comments 

   ![2023-12-03_121317](/img/vim-commentary/2023-12-03_121317.png)

   uncomments 

3. #### `gcap`: 

   Typing "`gcap`" in normal mode comments or uncomments an entire paragraph or block of text efficiently.

   ![2023-12-03_121703](/img/vim-commentary/2023-12-03_121703.png)

   comments 

   ![2023-12-03_121710](/img/vim-commentary/2023-12-03_121710.png)

   uncomments 

### Command Line Mode:

1. #### `:107,113Commentary`: 

   This command lets us comment or uncomment lines 107 to 113. Executing the command again will undo the action.

   ![2023-12-03_121851](/img/vim-commentary/2023-12-03_121851.png)

   comments 

   ![2023-12-03_121942](/img/vim-commentary/2023-12-03_121942.png)

   uncomments 

2. #### `:g/alias /Commentary`: 

   By using this command, we can comment or uncomment lines that match a specific pattern, such as "**alias** " Repeating the command will revert the action.

   ![2023-12-03_122054](/img/vim-commentary/2023-12-03_122054.png)

   comments 

   ![2023-12-03_122102](/img/vim-commentary/2023-12-03_122102.png)

   uncomments 

### Visual Mode:

The other modes, Vim also offers a Visual Mode. In this mode, we can select lines and use the "`gc`" command to comment or uncomment them effortlessly.

![2023-12-03_122226](/img/vim-commentary/2023-12-03_122226.png)

comments 

![2023-12-03_122242](/img/vim-commentary/2023-12-03_122242.png)

uncomments 

---

### File Type Supported

> These filetypes include TOML, plain text, C, C++, C#, Java, Kotlin, YAML, and Apache configuration files.

Insert the command in the `.vimrc` file

~~~bash
cat >> ~/.vimrc << EOF
autocmd FileType toml,txt,c,cpp,cs,java,kotlin,yaml,apache setlocal commentstring=#\ %s
EOF
~~~


---

### Conclusion:

The vim-commentary plug-in significantly enhances text editing efficiency. 

By familiarizing ourselves with its capabilities, we gain the ability to seamlessly comment on or uncomment lines, paragraphs, and even specific patterns of text. 

---

### Reference:

- https://github.com/tpope/vim-commentary

---

### Related:

- [Linux 的命令基本用法 - vim 編輯器](https://kingtam.win/archives/vim.html)

- [Install VIM-PLUG on Synology DSM](https://kingtam.eu.org/posts/dsm-custom/#install-vim-plug-on-synology-dsm)
- [NeoVim and Vim plugins Install in Alpine Linux](https://kingtam.eu.org/posts/alpine-customization/#neovim-and-vim-plugins-install-in-alpine-linux)

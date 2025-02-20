---
title: "Tmux"
date: 2025-02-20T20:35:52+08:00
draft: false
author: "King Tam"
summary: "Tmux (short for Terminal Multiplexer) is a powerful tool that allows you to manage multiple terminal sessions within a single window." 
showToc: true
categories:
- Linux
tags:
- tmux
- 
ShowLastMod: true
cover:
    image: "img/tmux/Cover-tmux.jpeg"
---

Tmux (short for Terminal Multiplexer) is a powerful tool that allows you to manage multiple terminal sessions within a single window.

------

### **1. Installing Tmux**

Most Linux distributions come with Tmux pre-installed. If not, you can install it using your package manager:

- **Debian/Ubuntu:**

  ```bash
  sudo apt install tmux
  ```

- **Fedora:**

  ```bash
  sudo dnf install tmux
  ```

- **Arch Linux:**

  ```bash
  sudo pacman -S tmux
  ```

------

### **2. Starting Tmux**

To start a new Tmux session, simply type:

```bash
tmux
```

This will open a new session with a single window. You’ll notice a status bar at the bottom of the screen, which displays information about your session.

------

### **3. Basic Tmux Commands**

Tmux uses a prefix key to execute commands. By default, the prefix is `Ctrl + b`. After pressing the prefix, you can enter a command.

#### **Common Commands:**

- **Create a new window:**

  ```bash
  Ctrl + b, then c
  ```

- **Switch between windows:**

  ```bash
  Ctrl + b, then [window number] (e.g., 0, 1, 2)
  ```

- **Split window horizontally:**

  ```bash
  Ctrl + b, then "
  ```

- **Split window vertically:**

  ```bash
  Ctrl + b, then %
  ```

- **Detach from the session (keep it running in the background):**

  ```bash
  Ctrl + b, then d
  ```

- **Reattach to a session:**

  ```bash
  tmux attach
  ```

- **List all sessions:**

  ```bash
  tmux ls
  ```

- **Kill a session:**

  ```bash
  tmux kill-session -t [session_name]
  ```

------

### **4. Customizing Tmux**

Customize Tmux by editing its configuration file, typically located at `~/.tmux.conf`. Here’s an example of a simple configuration:

```bash
cat << EOF > ~/.tmux.conf
## Change the prefix key to Ctrl + a (easier to reach than Ctrl + b)
# unbind C-b
# set-option -g prefix C-a
# bind C-a send-prefix

# Enable mouse support (for scrolling, resizing panes, etc.)
set -g mouse on

# Set the status bar to the top
set-option -g status-position top

# Use a more visually appealing status bar
set -g status-bg colour235
set -g status-fg white
set -g status-left-length 50
set -g status-right-length 50

# Reload the config file with Ctrl + a, then r
bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf"

# Start window and pane numbering at 1 (easier to switch to)
set -g base-index 1
setw -g pane-base-index 1

# Use vi mode for copy-paste (useful for vim users)
setw -g mode-keys vi

# Easier window navigation
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

# Resize panes more easily
bind-key -r H resize-pane -L 5
bind-key -r J resize-pane -D 5
bind-key -r K resize-pane -U 5
bind-key -r L resize-pane -R 5

# Automatically renumber windows when one is closed
set-option -g renumber-windows on

# Increase scrollback buffer size
set -g history-limit 10000

# Enable true color support (for better colors in terminal)
set -g default-terminal "screen-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"

EOF
```

After making changes, reload the configuration with:

```bash
tmux source-file ~/.tmux.conf
```

------

### **5. Practical Use Cases for Tmux**

- **Remote Development:** Tmux is perfect for remote servers. You can detach from a session and reattach later without losing your work.
- **Multitasking:** Run multiple commands simultaneously in split windows.
- **Scripting:** Automate tasks by scripting Tmux commands.

------

### **6. Creating a Blog Post Using Tmux**

If you’re writing a blog post, Tmux can help you stay organized. Here’s how:

1. **Start a new Tmux session:**

   ```bash
   tmux new -s blog
   ```

2. **Split the window:**

   - Use `Ctrl + b, then %` to split vertically.
   - Use `Ctrl + b, then "` to split horizontally.

3. **Use one pane for writing:**

   - Open your text editor (e.g., Vim, Nano) in one pane.

4. **Use another pane for previewing:**

   - If you’re using a static site generator like Hugo or Jekyll, run the local server in another pane.

5. **Detach and reattach as needed:**

   - Detach with `Ctrl + b, then d`.
   - Reattach with `tmux attach -t blog`.

------

### **7. Conclusion**

Tmux is a versatile tool that can significantly enhance your productivity on the command line. Whether you’re managing servers, writing code, or even creating a blog post, Tmux provides a streamlined way to handle multiple tasks. Give it a try, and you’ll soon wonder how you ever worked without it!
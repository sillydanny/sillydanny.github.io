#!/bin/bash

# Script name: alpine-customization.sh
# Author: King Tam
# Website: https://kingtam.eu.org
# Date: February 28, 2025
# Purpose: Customize Alpine Linux as described in https://kingtam.eu.org/posts/alpine-customization/

# Function to update and install packages
install_packages() {
    echo "Updating package repositories..."
    if ! apk update; then
        echo "Failed to update repositories. Exiting."
        exit 1
    fi

    echo "Installing essential packages..."
    apk add \
        bash curl git vim tmux \
        openssh sudo shadow util-linux \
        doas btop tree || {
        echo "Failed to install packages. Exiting."
        exit 1
    }

    echo "Packages installed successfully!"
}

# Function to configure sudo and doas
configure_sudo_doas() {
    echo "Configuring sudo and doas..."

    # Allow wheel group to use sudo
    echo "%wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/wheel > /dev/null || {
        echo "Failed to configure sudo. Exiting."
        exit 1
    }

    # Configure doas
    echo "permit :wheel" | tee /etc/doas.d/doas.conf > /dev/null || {
        echo "Failed to configure doas. Exiting."
        exit 1
    }
    chmod 0400 /etc/doas.d/doas.conf

    echo "sudo and doas configured successfully!"
}

# Function to add a user
add_user() {
    read -p "Enter the username: " username
    if ! adduser -G wheel -s /bin/bash "$username"; then
        echo "Failed to add user. Exiting."
        exit 1
    fi
    echo "User $username added successfully!"
}

# Function to configure Bash as the default shell
configure_bash() {
    echo "Configuring Bash as the default shell..."

    # Install Bash and related packages
    apk add bash bash-doc bash-completion || {
        echo "Failed to install Bash. Exiting."
        exit 1
    }

    # Change the default shell for the current user
    chsh -s /bin/bash "$(whoami)" || {
        echo "Failed to change default shell. Exiting."
        exit 1
    }

    echo "Bash configured successfully!"
}

# Function to configure Vim
configure_vim() {
    echo "Configuring Vim..."

    # Install Vim-Plug
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || {
        echo "Failed to install Vim-Plug. Exiting."
        exit 1
    }

    # Write Vim configuration
    cat << EOF > ~/.vimrc
call plug#begin()
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'joshdick/onedark.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
call plug#end()

nnoremap <F5> :NERDTreeToggle<CR>
syntax enable
set background=dark
set encoding=utf8
set ffs=unix,dos,mac
set t_Co=256

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_experimental_simple_template_highlight=1
let g:cpp_concepts_highlight=1

autocmd FileType toml,txt,c,cpp,cs,java,kotlin,yaml,apache setlocal commentstring=#\ %s
EOF

    echo "Vim configured successfully!"
}

# Function to configure Tmux
configure_tmux() {
    echo "Configuring Tmux..."

    # Write Tmux configuration
    cat << EOF > ~/.tmux.conf
set -g mouse on
set-option -g status-position top
set -g status-bg colour235
set -g status-fg white
set -g status-left-length 50
set -g status-right-length 50
bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf"
set -g base-index 1
setw -g pane-base-index 1
setw -g mode-keys vi
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R
bind-key -r H resize-pane -L 5
bind-key -r J resize-pane -D 5
bind-key -r K resize-pane -U 5
bind-key -r L resize-pane -R 5
set-option -g renumber-windows on
set -g history-limit 10000
set -g default-terminal "screen-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"
EOF

    echo "Tmux configured successfully!"
}

# Function to configure SSH
configure_ssh() {
    echo "Configuring SSH..."

    # Generate SSH keys if they don't exist
    if [ ! -f ~/.ssh/id_rsa ]; then
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N "" || {
            echo "Failed to generate SSH keys. Exiting."
            exit 1
        }
    fi

    # Start SSH service
    rc-service sshd start && rc-update add sshd || {
        echo "Failed to configure SSH. Exiting."
        exit 1
    }

    echo "SSH configured successfully!"
}

# Main Menu
while true; do
    clear
    echo "=== Alpine Linux Customization ==="
    echo "1. Install Packages"
    echo "2. Configure sudo and doas"
    echo "3. Add a User"
    echo "4. Configure Bash as Default Shell"
    echo "5. Configure Vim"
    echo "6. Configure Tmux"
    echo "7. Configure SSH"
    echo "0. Exit"
    echo "================================="

    read -p "Enter your choice: " choice

    case $choice in
        1) install_packages ;;
        2) configure_sudo_doas ;;
        3) add_user ;;
        4) configure_bash ;;
        5) configure_vim ;;
        6) configure_tmux ;;
        7) configure_ssh ;;
        0) echo "Goodbye!"; exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac

    read -p "Press Enter to continue..."
done

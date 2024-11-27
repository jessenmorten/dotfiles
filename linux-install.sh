#!/bin/bash
set -e

log () {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -e "\033[90m$timestamp\033[0m ➜  $1"
}

log "Removing existing NeoVim configuration..."
rm -rf ~/.config/nvim

log "Copying NeoVim configuration..."
cp -r ./nvim ~/.config/nvim

log "Removing existing Tmux configuration..."
rm -rf ~/.tmux

log "Cloning Tmux Plugin Manager..."
git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm

log "Copying Tmux configuration..."
cp ./tmux/.tmux.conf ~/.tmux.conf

log "Removing existing Zsh configuration..."
rm ~/.zshrc

log "Copying Zsh configuration..."
cp ./zsh/.zshrc ~/.zshrc

log "Dotfiles installed successfully!"

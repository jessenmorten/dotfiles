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

log "Dotfiles installed successfully!"

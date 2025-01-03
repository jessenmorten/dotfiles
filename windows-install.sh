#!/bin/bash
set -e

log () {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -e "\033[90m$timestamp\033[0m ➜  $1"
}

log "Removing existing NeoVim configuration..."
rm -rf $USERPROFILE/AppData/Local/nvim

log "Copying NeoVim configuration..."
cp -r ./nvim $USERPROFILE/AppData/Local/nvim

log "Removing existing Git configuration..."
rm -rf $HOME/.config/git

log "Copying Git configuration..."
cp -r ./git $HOME/.config/git

log "Dotfiles installed successfully!"

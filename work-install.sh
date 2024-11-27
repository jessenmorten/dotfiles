#!/bin/bash
set -e

log () {
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -e "\033[90m$timestamp\033[0m ➜  $1"
}

log "Removing existing NeoVim configuration..."
rm -r $USERPROFILE/AppData/Local/nvim

log "Copying NeoVim configuration..."
cp -r ./nvim $USERPROFILE/AppData/Local/nvim

log "Removing buggy treesitter configuration..."
rm $USERPROFILE/AppData/Local/nvim/lua/jessenmorten/plugins/treesitter.lua

log "Removing existing Git configuration..."
rm -r ~/.config/git

log "Copying Git configuration..."
cp -r ./git ~/.config/git

log "Dotfiles installed successfully!"

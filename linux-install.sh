echo "Installing dotfiles..."

# NeoVim
echo "Installing NeoVim configuration..."
rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/nvim

# Tmux
echo "Installing Tmux configuration..."
rm -rf ~/.tmux/plugins/tpm
rm -rf ~/.tmux
git clone https://github.com/tmux-plugins/tpm.git ~/.tmux/plugins/tpm
cp ./tmux/.tmux.conf ~/.tmux.conf

# Install complete
echo "Dotfiles installed successfully!"

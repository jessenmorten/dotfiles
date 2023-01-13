echo "Installing dotfiles..."

# NeoVim
echo "Installing NeoVim configuration..."
rm -rf ~/.config/nvim
cp -r ./nvim ~/.config/nvim

# Install complete
echo "Dotfiles installed successfully!"

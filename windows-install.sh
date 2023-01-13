echo "Installing dotfiles..."

# NeoVim
echo "Installing NeoVim configuration..."
rm -rf $USERPROFILE/AppData/Local/nvim
cp -r ./nvim $USERPROFILE/AppData/Local/nvim

# Install complete
echo "Dotfiles installed successfully!"

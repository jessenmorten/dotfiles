# Exit script if any statement returns a non-true return value
set -e

# NeoVim
echo "Installing NeoVim configuration..."
rm -rf $USERPROFILE/AppData/Local/nvim
cp -r ./nvim $USERPROFILE/AppData/Local/nvim
rm $USERPROFILE/AppData/Local/nvim/lua/jessenmorten/plugins/treesitter.lua

# Git
echo "Installing Git configuration..."
rm -rf ~/.config/git
cp -r ./git ~/.config/git

# Install complete
echo "Dotfiles installed successfully!"

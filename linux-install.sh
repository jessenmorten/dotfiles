# Exit script if any statement returns a non-true return value
set -e

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

# Zsh
echo "Installing Zsh configuration..."
rm ~/.zshrc
cp ./zsh/.zshrc ~/.zshrc

# Install complete
echo "Dotfiles installed successfully!"

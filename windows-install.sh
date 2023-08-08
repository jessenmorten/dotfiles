# Exit script if any statement returns a non-true return value
set -e

# Ensure dependencies are installed
echo "Checking dependencies..."
git --version
nvim --version
cargo --version
rustc --version
rustup --version
rg --version
go version
make --version

# NeoVim
echo "Installing NeoVim configuration..."
rm -rf $USERPROFILE/AppData/Local/nvim
cp -r ./nvim $USERPROFILE/AppData/Local/nvim

# Git
echo "Installing Git configuration..."
rm -rf $HOME/.config/git
cp -r ./git $HOME/.config/git

# Install complete
echo "Dotfiles installed successfully!"

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

# Alacritty
echo "Installing Alacritty configuration..."
rm -rf $USERPROFILE/AppData/Roaming/alacritty
cp -r ./alacritty $USERPROFILE/AppData/Roaming/alacritty

# Install complete
echo "Dotfiles installed successfully!"

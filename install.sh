#!/bin/bash

DOTFILES_DIR=~/dotfiles

# List of dotfiles
DOTFILES=(".zshrc" ".bashrc" ".vimrc" ".gitconfig")

# Install essential packages
# echo "Installing essential & cosmetic packages (zsh, fastfetch, neovim)"
sudo pacman -Syu --noconfirm
sudo pacman -S vim git zsh base-devel fastfetch fontconfig --noconfirm
sudo pacman -S neovim --noconfirm

# Install necessary packages for Neovim plugins
echo "Installing neovim dependencies..."
sudo pacman -S python-pynvim nodejs npm ripgrep fzf ctags --noconfirm

# Create Neovim config directory if it doesn't exist
echo "Setting up Neovim configuration..."
mkdir -p ~/.config/nvim

# Backup existing init.vim if it exists
if [ -f ~/.config/nvim/init.vim ]; then
  echo "Backing up existing init.vim..."
  mv ~/.config/nvim/init.vim ~/.config/nvim/init.vim.bak
fi

# Symlink init.vim from dotfiles repository
ln -s ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim

# Install vim-plug for Neovim
echo "Installing vim-plug..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install Neovim plugins
echo "Installing Neovim plugins..."
nvim +PlugInstall +qall

echo "Neovim setup complete!"

# Create symlinks
echo "Create symlinks for all dotfiles"
echo "Dotfiles will not be in ~ They will be linked to the dotfiles github"
for file in "${DOTFILES[@]}"; do
    ln -sf "$DOTFILES_DIR/$file" ~/"$file"
done

# Copy clear.sh to home FONT_DIR
echo "Create the clear.sh script and add it to ~"
echo "When clear is typed in the terminal, fastfetch and clear will run"
cp "$DOTFILES_DIR/clear.sh" ~/

# Install Powerlevel10k theme
echo "Install Powerlevel10k theme for zsh"
POWERLEVEL10K_DIR=~/.local/share/powerlevel10k
if [ ! -d "$POWERLEVEL10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_DIR"
fi

# Install Zsh Syntax Highlightin
echo "Install Zsh Syntax Highlightin"
ZSH_SYNTAX_HIGHLIGHTING_DIR=~/.local/share/zsh-syntax-highlighting
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
fi

# Download and install MesloLGS NF fonts
echo "Download and install MesloLGS NF fonts"
FONT_DIR=~/.local/share/fonts
mkdir -p "$FONT_DIR"

# List of fonts to download
FONTS=(
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
)

for font in "${FONTS[@]}"; do
    curl -fLo "$FONT_DIR/$(basename "$font")" "$font"
done

# Update font cache
echo "Update font cache"
fc-cache -fv

# Install yay
echo "Install yay (yougert package manager) | It's like pacman on steroids"
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

# Install some packages
yay -S neofetch fastfetch cloudflared upower --noconfirm

# Append source lines to .zshrc
echo 'source ~/.local/share/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
echo 'source ~/.local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' >> ~/.zshrc

# Change default shell to zsh
echo "Change default shell to zsh"
chsh -s $(which zsh)

# Source the new zshrc if exists
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi

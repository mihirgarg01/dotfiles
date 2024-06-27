#!/bin/bash

DOTFILES_DIR=~/dotfiles

# List of dotfiles
DOTFILES=(".zshrc" ".bashrc" ".vimrc" ".gitconfig")

# Install essential packages
sudo pacman -Syu --noconfirm
sudo pacman -S vim git zsh base-devel fontconfig --noconfirm

# Create symlinks
for file in "${DOTFILES[@]}"; do
    ln -sf "$DOTFILES_DIR/$file" ~/"$file"
done

# Copy clear.sh to home dir
cp "$DOTFILES_DIR/clear.sh" ~/

# Install Powerlevel10k theme
POWERLEVEL10K_DIR=~/.local/share/powerlevel10k
if [ ! -d "$POWERLEVEL10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$POWERLEVEL10K_DIR"
fi

# Install Zsh Syntax Highlighting
ZSH_SYNTAX_HIGHLIGHTING_DIR=~/.local/share/zsh-syntax-highlighting
if [ ! -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX_HIGHLIGHTING_DIR"
fi

# Download and install MesloLGS NF fonts
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
fc-cache -fv

# Install yay
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
chsh -s $(which zsh)

# Source the new zshrc if exists
if [ -f ~/.zshrc ]; then
    source ~/.zshrc
fi

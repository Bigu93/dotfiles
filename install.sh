#!/bin/bash

# GLOBALS
DOTFILES_DIR="$HOME/dotfiles"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "--- Starting Setup Installation ---"

echo "--- Updating Repositories & Installing Packages ---"
sudo apt update
sudo apt install -y zsh git curl tmux stow guake xclip xsel

if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "--- Installing Oh My Zsh ---"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo "--- Oh My Zsh already installed ---"
fi

echo "--- Installing Heapbytes Theme ---"
if [ ! -d "$ZSH_CUSTOM/themes/heapbytes-zsh" ]; then
	git clone https://github.com/heapbytes/heapbytes-zsh.git "$ZSH_CUSTOM/themes/heapbytes-zsh"
	echo "Heapbytes theme installed."
else
	echo "Heapbytes theme already exists."
fi

echo "--- Installing Zsh Plugins ---"

install_plugin() {
    REPO_URL=$1
    PLUGIN_NAME=$2
    TARGET_DIR="$ZSH_CUSTOM/plugins/$PLUGIN_NAME"

    if [ ! -d "$TARGET_DIR" ]; then
        echo "Cloning $PLUGIN_NAME..."
        git clone "$REPO_URL" "$TARGET_DIR"
    else
        echo "✅ $PLUGIN_NAME already exists."
    fi
}

# Install the plugins list
install_plugin "https://github.com/zsh-users/zsh-autosuggestions.git" "zsh-autosuggestions"
install_plugin "https://github.com/zsh-users/zsh-syntax-highlighting.git" "zsh-syntax-highlighting"
install_plugin "https://github.com/zsh-users/zsh-history-substring-search" "zsh-history-substring-search"
install_plugin "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" "autoswitch_virtualenv"

echo "--- Linking Dotfiles via Stow ---"
if [ -d "$DOTFILES_DIR" ]; then
	cd "$DOTFILES_DIR"

	if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
		echo "Backing up existing .zshrc to .zshrc.bak"
		mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
	fi

	stow zsh
	stow tmux

	echo "Dotfiles linked!"
else
	echo "Error: Dotfiles directory not found at $DOTFILES_DIR"
fi

if [ "$SHELL" != "$(which zsh)" ]; then
	echo "--- Changing default shell to Zsh ---"
	chsh -s "$(which zsh)"
	echo "--- Shell changed. Please log out and back in."
fi

echo "--- Setup Complete! Restart your terminal. ---"

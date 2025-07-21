#!/bin/bash

sudo dnf update -y
sudo dnf install -y \
	git curl nodejs lua luajit \
	git-delta fzf ImageMagick \
	vim neovim less xsel helm \
	zsh tmux htop pnpm lsd cargo \
	tree unzip zip gcc make fd ripgrep tree-sitter

# Dotfiles
echo "setting up dotfiles"
cd ~/dotfiles && stow .

# Install lazygit
echo "installing lazygit"
LAZYGIT_VERSION=$(curl -sS https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name":' | awk '{gsub(/[",]/, "", $2); print $2}')
LG_TRIMED_VERSION=$(echo $LAZYGIT_VERSION | sed 's/v//')
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LG_TRIMED_VERSION}_Linux_x86_64.tar.gz"
curl -Lo /tmp/lazygit.tar.gz "$LAZYGIT_URL"
tar -xf /tmp/lazygit.tar.gz -C /tmp
sudo install -Dm755 /tmp/lazygit /usr/local/bin/lazygit

# Install silicon screenshot tool
echo "installing silicon"
SILICON_URL="https://github.com/Aloxaf/silicon/releases/download/v0.5.2/silicon-v0.5.2-x86_64-unknown-linux-gnu.tar.gz"
curl -Lo /tmp/silicon.tar.gz "$SILICON_URL"
tar -xf /tmp/silicon.tar.gz -C /tmp
sudo install -Dm755 /tmp/silicon /usr/local/bin/silicon

# Install Golang
echo "getting go version"
version=$(curl -s https://go.dev/dl/ | grep -E -o "go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz" | head -n 1)
echo "installing version ${version}"
curl -L "https://go.dev/dl/${version}" | tar -C /tmp -xz
sudo mv /tmp/go /usr/local/
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile

# Install tmux plugins
echo "installing tmux package manager and plugins"
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins

# Installing kubectl
curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
sudo install -Dm755 /tmp/kubectl /usr/local/bin/kubectl

# Shell config
echo "setting up zsh as default"
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

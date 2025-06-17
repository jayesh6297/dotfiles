#!/usr/bin/bash

echo "installing packages"
sudo dnf install -y git curl neovim ripgrep fd-find tree dnf-plugins-core lsd helm fzf

echo "installing docker"
sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER
sudo newgrp docker
sudo systemctl enable --now docker.service containerd.service

echo "setting up dotfiles"
stow ~/dotfiles

echo "installing kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -Dm755 kubectl /usr/local/bin/

echo "installing tpm and plugin"
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
~/.config/tmux/plugins/tpm/bin/install_plugins

echo "setting up zsh as default"
chsh -s $(which zsh)
sudo chsh -s $(which zsh)

echo "getting go version"
version=$(curl -s https://go.dev/dl/ | grep -E -o "go[0-9]+\.[0-9]+\.[0-9]+\.linux-amd64\.tar\.gz" | head -n 1)
echo "installing golang version ${version}"
curl -L "https://go.dev/dl/${version}" | sudo tar -C /usr/local -xz
echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile

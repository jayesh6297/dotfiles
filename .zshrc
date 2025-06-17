# exports
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:/usr/local/protoc/bin"
export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
export EDITOR="nvim"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::docker-compose
zinit snippet OMZP::git-commit
zinit snippet OMZP::pip
zinit snippet OMZP::pipenv
zinit snippet OMZP::python
zinit snippet OMZP::rust
zinit snippet OMZP::golang
zinit snippet OMZP::npm
zinit snippet OMZP::colorize

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Aliases
alias kc="kubectl"
alias zshconfig="nvim ~/.zshrc"
alias sudo="sudo "
alias ls="lsd"
alias ll="ls -la"
alias la="ls -a"
alias lg="lazygit"
alias nv="nvim"
alias aquired-ports="sudo lsof -i -P -n | grep LISTEN"
alias zshclear=" echo "" > ~/.zsh_history"
alias python="python3 "
alias termius="~/.config/scripts/termius.sh"

# Copy selected recording file to d drive
recp() {
    selected_file=$(ll /mnt/c/Users/jayesh.kale/Videos/Captures | awk '{print $NF}' | fzf)
    if [ -n "$selected_file" ]; then
        cp "/mnt/c/Users/jayesh.kale/Videos/Captures/$selected_file" /mnt/d/
        echo "File copied: $selected_file"
    else
        echo "No file selected"
    fi
}

# aws context set for kubectl
kctx() {
  local contexts=(
	 fleetpoc2-k8s_svc
	 fleetpoc3-k8s_svc
	 fleetscale-k8s_svc
	 hcipoc-k8s_svc
	 rop-poc01-k8s_svc
	 ropint-k8s_svc
	 scdev01-k8s_svc
	 scdev03-k8s_svc
	 scdev04-k8s_svc
	 scint-k8s_svc
	 fleetpoc2-setup
	 fleetpoc3-setup
	 fleetscale-setup
	 hcipoc-setup
	 rop-poc01-setup
	 ropint-setup
	 scdev01-setup
	 scdev03-setup
	 scdev04-setup
	 scint-setup
	 fleetpoc2-ro
	 fleetpoc3-ro
	 fleetscale-ro
	 hcipoc-ro
	 rop-poc01-ro
	 ropint-ro
	 scdev01-ro
	 scdev03-ro
	 scdev04-ro
	 scint-ro
	 fleetpoc2-hci_manager
	 fleetpoc3-hci_manager
	 fleetscale-hci_manager
	 hcipoc-hci_manager
	 rop-poc01-hci_manager
	 ropint-hci_manager
	 scdev01-hci_manager
	 scdev03-hci_manager
	 scdev04-hci_manager
	 scint-hci_manager
	 fleetpoc2-privatecloud_ai
	 fleetpoc3-privatecloud_ai
	 fleetscale-privatecloud_ai
	 hcipoc-privatecloud_ai
	 rop-poc01-privatecloud_ai
	 ropint-privatecloud_ai
	 scdev01-privatecloud_ai
	 scdev03-privatecloud_ai
	 scdev04-privatecloud_ai
	 scint-privatecloud_ai 
  )

  # Use fzf to select a context
  local selected=$(printf "%s\n" "${contexts[@]}" | fzf --prompt="Select Kubernetes context: ")

  # Set the context if selection was made
  if [[ -n "$selected" ]]; then
    kubectl config use-context "$selected"
  else
    echo "No context selected."
  fi
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
cds_list_bastions() {
  aws --profile SSMSessionManager --region us-west-2 ec2 describe-instances --filters Name=tag-key,Values=Name Name=tag:identifier,Values=bastion_hosts --query 'Reservations[*].Instances[*].{_ID_:InstanceId,Name:Tags[?Key==`Name`]|[0].Value} | sort_by([], &Name)' --output table
}
alias cds-list-bastions='cds_list_bastions'
# Function to start an AWS session

awssession() {
  aws ssm start-session --profile SSMSessionManager --target $(aws ec2 describe-instances --profile SSMSessionManager --filters Name=tag:Name,Values=$1 | jq -r '.Reservations[].Instances[] | .InstanceId')
}

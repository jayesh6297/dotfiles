#!/bin/bash

HOST_FILE="${HOME}/.config/scripts/data/termius/ssh_table"

# Check if required tools are installed
for cmd in fzf sshpass tmux; do
	if ! command -v $cmd &>/dev/null; then
		echo "$cmd not found. Please install it first."
		exit 1
	fi
done

# Check if host file exists
if [[ ! -f "$HOST_FILE" ]]; then
	echo "Host file $HOST_FILE not found!"
	exit 1
fi

# Use fzf to select just the label
selected_label=$(cut -d',' -f1 "$HOST_FILE" | fzf)

# Check if selection was made
if [[ -z "$selected_label" ]]; then
	echo "No selection made."
	exit 1
fi

# Get the full entry by matching the selected label
entry=$(grep "^${selected_label}," "$HOST_FILE")

if [[ -z "$entry" ]]; then
	echo "Label '$selected_label' not found."
	exit 1
fi

# Extract fields
IFS=',' read -r label ip user pass <<<"$entry"

# Start or attach to tmux session
SESSION_NAME="ssh_session"
tmux has-session -t $SESSION_NAME 2>/dev/null
if [[ $? != 0 ]]; then
	tmux new-session -d -s $SESSION_NAME -n "$label" "sshpass -p '$pass' ssh -o StrictHostKeyChecking=no $user@$ip; bash"
else
	tmux new-window -t $SESSION_NAME -n "$label" "sshpass -p '$pass' ssh -o StrictHostKeyChecking=no $user@$ip; bash"
fi

# Attach to the tmux session
tmux attach -t $SESSION_NAME

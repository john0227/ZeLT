#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source "${CWD}/options.conf"
tmux source "${CWD}/keybinds.conf"

# Create hook to collect keybinds whenever new session is created
tmux set-hook -ga session-created "run-shell ${CWD}/scripts/keybind_hook.sh"
# Create a keybind to allow users to run hook whenever they want
HOOK_KEY=$(tmux show-options -gqv @zelt_keybind_hook_key)
tmux bind -T prefix "$HOOK_KEY" "run-shell ${CWD}/scripts/keybind_hook.sh"


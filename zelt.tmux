#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source "${CWD}/options.conf"
tmux run-shell "${CWD}/keybinds.conf"

# Run hook whenever this file is run
${CWD}/scripts/keybind_hook.sh

# Add support for tmux-mode-indicator
TMUX_MODE_ENABLED="$(tmux show-option -gqv @zelt_enable_mode_indicator)"
if [[ "$TMUX_MODE_ENABLED" = "on" ]]; then
    tmux set -gq @mode_indicator_prefix_prompt "$(echo "#(${CWD}/scripts/mode_indicator.sh)")"
fi


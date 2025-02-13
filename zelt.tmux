#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source "${CWD}/options.conf"
tmux run-shell "${CWD}/keybinds.conf"

# Update keybind to show hints if user set it on
SHOW_PANE_HINT=$(tmux show-option -gqv @zelt_show_hint_pane)
SHOW_WINDOW_HINT=$(tmux show-option -gqv @zelt_show_hint_window)
SHOW_SESSION_HINT=$(tmux show-option -gqv @zelt_show_hint_session)

[[ $SHOW_PANE_HINT = "on" ]] && tmux bind -n C-p "switch-client -T pane-mode ; run-shell ${CWD}/scripts/display_pane_hints.sh ; switch-client -T root"
[[ $SHOW_WINDOW_HINT = "on" ]] && tmux bind -n C-w "switch-client -T window-mode ; run-shell ${CWD}/scripts/display_window_hints.sh ; switch-client -T root"
[[ $SHOW_SESSION_HINT = "on" ]] && tmux bind -n C-s "switch-client -T session-mode ; run-shell ${CWD}/scripts/display_session_hints.sh ; switch-client -T root"

# Create hook to collect keybinds whenever new session is created
HOOK="${CWD}/scripts/keybind_hook.sh"
if [[ -z "$(tmux show-hooks -g | grep 'keybind_hook.sh')" ]]; then
    tmux set-hook -ga session-created "run-shell $HOOK"
fi
# Create a keybind to allow users to run hook whenever they want
HOOK_KEY=$(tmux show-options -gqv @zelt_keybind_hook_key)
tmux bind -T prefix "$HOOK_KEY" "run-shell $HOOK"

# Run hook whenever this file is run
$HOOK

# Add support for tmux-mode-indicator
EMPTY_PROMPT="${CWD}/scripts/mode_indicator.sh"
tmux set -gq @mode_indicator_prefix_prompt "$(echo " #(${CWD}/scripts/mode_indicator.sh) ")"


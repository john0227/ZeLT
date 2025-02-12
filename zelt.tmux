#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux source "${CWD}/options.conf"
tmux source "${CWD}/keybinds.conf"

# Update keybind to show hints if user set it on
SHOW_PANE_HINT=$(tmux show-option -gqv @zelt_show_hint_pane)
SHOW_WINDOW_HINT=$(tmux show-option -gqv @zelt_show_hint_window)
SHOW_SESSION_HINT=$(tmux show-option -gqv @zelt_show_hint_session)

[[ $SHOW_PANE_HINT = "on" ]] && tmux bind -n C-p "switch-client -T pane-mode ; run-shell ${CWD}/scripts/display_pane_hints.sh"
[[ $SHOW_WINDOW_HINT = "on" ]] && tmux bind -n C-w "switch-client -T window-mode ; run-shell ${CWD}/scripts/display_window_hints.sh"
[[ $SHOW_SESSION_HINT = "on" ]] && tmux bind -n C-s "switch-client -T session-mode ; run-shell ${CWD}/scripts/display_session_hints.sh"

# Create hook to collect keybinds whenever new session is created
tmux set-hook -ga session-created "run-shell ${CWD}/scripts/keybind_hook.sh"
# Create a keybind to allow users to run hook whenever they want
HOOK_KEY=$(tmux show-options -gqv @zelt_keybind_hook_key)
tmux bind -T prefix "$HOOK_KEY" "run-shell ${CWD}/scripts/keybind_hook.sh"


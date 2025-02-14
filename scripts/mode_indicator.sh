#!/usr/bin/env bash

mode="$(tmux display -p '#{client_key_table}')"

PREFIX="$(tmux show-option -gqv @zelt_indicator_prefix_prompt)"
PANE="$(tmux show-option -gqv @zelt_indicator_pane_prompt)"
WINDOW="$(tmux show-option -gqv @zelt_indicator_window_prompt)"
SESSION="$(tmux show-option -gqv @zelt_indicator_session_prompt)"

case "$mode" in
    prefix)       echo "$PREFIX" ;;
    pane-mode)    echo "$PANE" ;;
    window-mode)  echo "$WINDOW" ;;
    session-mode) echo "$SESSION" ;;
    *) echo " TMUX " ;;
esac


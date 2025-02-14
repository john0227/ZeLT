#!/usr/bin/env bash

# List all sessions
function list_sessions() {
    local -r current_session="$(tmux display -p "#S")"
    # TODO: get sessions to filter
    local -r filter="scratch"
    tmux list-sessions -F "#S #{session_activity}" -f "#{!=:#S,$filter}" | sort -k2,2 -n | awk '{ print $1 }'
}

# fzf popup for user to choose session (or input a new one)
function session_popup() {
    local -r title="$1"
    local -r all_sessions="$(list_sessions)"
    local -r res=$(echo "$all_sessions" |
        fzf --tmux=center,60,15 --print-query --tac --border-label=" $title " --border-label-pos 5 |
        tail -n1)
    echo "$res"
}

# Switch to another session
# If the session user gives does not exist, create and switch
function switch_session() {
    local title="$1"
    if [[ -z $title ]]; then
        title="Switch Session"
    fi

    local -r session="$(session_popup "$title")"

    # If no session is provided, NOOP
    [[ -z "$session" ]] && return 0

    if ! tmux has-session -t "$session" 2> /dev/null; then
        tmux new-session -d -s "$session"
    fi
    tmux switch-client -t "$session"
}

function create_session() {
    switch_session "Create New Session"
}

function kill_session() {
    local -r title="Kill Session"

    local -r session="$(session_popup "$title")"

    # If no session is provided, NOOP
    [[ -z "$session" ]] && return 0

    if tmux has-session -t "$session" 2> /dev/null; then
        tmux kill-session -t "$session"
    fi
}

# Move pane to specified session
# If the session user gives does not exist, create and move
function move_pane() {
    local -r title="Select Session to Move Pane"

    session="$(session_popup "title")"

    # If provided session is empty or equal to current, NOOP
    local -r current_session="$(tmux display -p "#S")"
    [[ -z "$session" || "$session" = "$current_session" ]] && return 0

    if ! tmux has-session -t "$session" 2> /dev/null; then
        tmux break-pane
        local -r current_window="$(tmux display -p "#{window_id}")"
        tmux new-session -d -s "$session"
        tmux move-window -k -s "$current_window" -t "$session:1" && tmux switch-client -t "$session"
    else
        local -r num_windows="$(tmux display-message -p "#{session_windows}")"
        local -r num_panes="$(tmux display-message -p "#{window_panes}")"
        # Create window to prevent killing session
        [[ $num_windows -eq 1 && $num_panes -eq 1 ]] && tmux new-window -d
        tmux break-pane -t "$session" && tmux switch-client -t "$session"
    fi
}

# Move window to specified session
# If the session user gives does not exist, create and move
function move_window() {
    local -r title="Select Session to Move Window"

    session="$(session_popup "title")"

    # If provided session is empty or equal to current, NOOP
    local -r current_session="$(tmux display -p "#S")"
    [[ -z "$session" || "$session" = "$current_session" ]] && return 0

    if ! tmux has-session -t "$session" 2> /dev/null; then
        local -r current_window="$(tmux display -p "#{window_id}")"
        tmux new-session -d -s "$session"
        tmux move-window -k -s "$current_window" -t "$session:1" && tmux switch-client -t "$session"
    else
        local -r num_windows="$(tmux display-message -p "#{session_windows}")"
        # Create window to prevent killing session
        [[ $num_windows -eq 1 ]] && tmux new-window -d
        tmux move-window -t "$session" && tmux switch-client -t "$session"
    fi
}

# Link window to specified session
# If the session user gives does not exist, create and link
function link_window() {
    local -r title="Select Session to Link Window"

    session="$(session_popup "title")"

    # If provided session is empty or equal to current, NOOP
    local -r current_session="$(tmux display -p "#S")"
    [[ -z "$session" || "$session" = "$current_session" ]] && return 0

    if ! tmux has-session -t "$session" 2> /dev/null; then
        local -r current_window="$(tmux display -p "#{window_id}")"
        tmux new-session -d -s "$session"
        tmux link-window -k -s "$current_window" -t "$session:1" && tmux switch-client -t "$session"
    else
        local -r num_windows="$(tmux display-message -p "#{session_windows}")"
        tmux switch-client -t "$session" && tmux link-window -t "$session"
    fi
}
action=$1
case "${action}" in
    switch)      switch_session ;;
    create)      create_session ;;
    kill)        kill_session ;;
    move_pane)   move_pane ;;
    move_window) move_window ;;
    link_window) link_window ;;
    *) echo "Invalid action: \"${action}\"" ;;
esac


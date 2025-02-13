#!/usr/bin/env bash

function list_sessions() {
    current_session=$(tmux display -p "#S")
    # TODO: get sessions to filter
    filter="scratch"
    tmux list-sessions -F "#S" -f "#{!=:#S,$filter}"
}

function session_popup() {
    title="$1"
    all_sessions=$(list_sessions)
    res=$(echo "$all_sessions" | 
        fzf --tmux=center,60,15 --print-query --tac --border-label=" $title " --border-label-pos 5 |
        tail -n1)
    echo "$res"
}

function switch_session() {
    title="$1"
    if [[ -z $title ]]; then
        title="Switch Session"
    fi

    session=$(session_popup "$title")

    # If no session is provided, NOOP
    [[ -z $session ]] && return 0

    if ! tmux has-session -t $session 2> /dev/null; then
        tmux new-session -d -s $session
    fi
    tmux switch-client -t $session
}

function create_session() {
    switch_session "Create New Session"
}

function kill_session() {
    title="Kill Session"

    session=$(session_popup "$title")

    # If no session is provided, NOOP
    [[ -z $session ]] && return 0

    if tmux has-session -t $session 2> /dev/null; then
        tmux kill-session -t $session
    fi
}

action=$1
case "${action}" in
    switch) switch_session ;; 
    create) create_session ;;
    kill) kill_session ;;
    *) echo "Invalid action: \"${action}\"" ;;
esac


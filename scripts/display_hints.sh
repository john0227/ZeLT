#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname $CWD)"

MODE=$1

MENU_ITEMS=$(awk '
{
    key_cmd = substr($0, index($0, $2));
    title = key_cmd;
    if (length(title) > 55) {
        title = substr(title, 1, 52)"...";
    }
    gsub(/#/, "##", title);
    print "!"title"!", $1, "!"key_cmd"!"
}' "${ROOT}/hints/${MODE}.txt" | tr '!\n' "' ")

MENU_X="$(tmux show-option -gqv @zelt_hint_menu_x)"
MENU_Y="$(tmux show-option -gqv @zelt_hint_menu_y)"

DISPLAY_MENU="tmux display-menu -x $MENU_X -y $MENU_Y $MENU_ITEMS"
eval $DISPLAY_MENU


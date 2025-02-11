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

CMD="tmux display-menu -x 0 -y S $MENU_ITEMS"
eval $CMD


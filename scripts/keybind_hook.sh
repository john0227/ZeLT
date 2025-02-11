#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname $CWD)"
FILE="${ROOT}/hints/&1.txt"

for mode in "pane" "window" "session"; do
    _FILE=$(sed "s/&1/$mode/g" <<< $FILE)
    # escape non-alphanumeric keybinds (that are not already escaped)
    # tmux escapes '\' by default
    tmux list-keys -T "${mode}-mode" | sed "s/.*${mode}-mode //g" | sed -E 's/^[^0-9a-zA-Z\]/\\&/g' | sort -s -b -k2,2 > $_FILE
done


#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname $CWD)"
FILE="${ROOT}/hints/&1.txt"

for mode in "pane" "window" "session"; do
    _FILE=$(sed "s/&1/$mode/g" <<< $FILE)
    tmux list-keys -T "${mode}-mode" | sed "s/.*${mode}-mode //g" | sort -s -b -k2,2 > $_FILE
done


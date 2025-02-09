#!/usr/bin/env bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(dirname $CWD)"

MODE=$1

MENU_ITEMS=$(awk '
{
    print "!"substr($0, index($0,$2))"!", $1, "!"substr($0, index($0,$2))"!"
}' "${ROOT}/hints/${MODE}.txt" | tr '!\n' "' ")

CMD="tmux display-menu -x 0 -y S $MENU_ITEMS"
eval $CMD


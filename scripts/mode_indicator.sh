#!/usr/bin/env bash

mode=$(tmux display -p '#{client_key_table}')

if [[ mode = "prefix" ]]; then
    echo "WAIT"
else
    echo "$(tr '[:lower:]' '[:upper:]' <<< ${mode//-mode/})"
fi


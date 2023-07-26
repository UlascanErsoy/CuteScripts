#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$(find $1 -mindepth 1 -maxdepth 1 -type d | fzf-tmux)

else
    selected=$(find ~/workspace ~/workspace/rust-ml ~/workspace/learn-rust/ ~/workspace/how-to-websocket/ -mindepth 1 -maxdepth 1 -type d | fzf-tmux)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name

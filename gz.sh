#!/bin/sh

SELECTED=$(find $HOME -name .git -exec dirname '{}' + | fzf);

tmux neww -n $(basename $SELECTED)

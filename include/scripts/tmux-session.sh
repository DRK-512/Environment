#!/bin/bash
if [[ -z "$1" ]]; then 
    echo "Please provide a session number, available are:"
    tmux list-sessions
    exit 0
fi

tmux attach -t $1

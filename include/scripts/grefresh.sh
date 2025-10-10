#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script just makes sure your git repository is up to date"
    echo "This script was made to shorten the need typing the long git pull & submodule update commands"
    echo ""
    echo "Usage: $0"
    echo "-h, --help    Display this help message"
    exit 0
fi

git pull
git submodule update --init --recursive

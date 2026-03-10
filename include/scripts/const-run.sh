#!/bin/bash

# Function to display the help menu
function display_help() {
    echo "Usage: $0 <command>"
    echo
    echo "This script runs the specified command repeatedly every second."
    echo
    echo "Options:"
    echo "  -h, --help    Display this help menu and exit."
    echo
    echo "Example:"
    echo "  $0 ls -l"
    echo "  This will run 'ls -l' every second."
}

# Check if the user requested help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check if no arguments are provided
if [[ -z ${@} ]]; then
    echo "Error: No command provided."
    echo "Use -h or --help for usage information."
    exit 1
fi

# Main loop to run the command repeatedly
while true
do
    $@
    sleep 1
done


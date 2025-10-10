#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script was made to see if you have internet connection"
    echo "If you have internet, you will get a message saying Connected"
    echo "If you are not connected to the internet, then you will get a message stating Disconnected"
    echo ""
    echo "Usage: $0"
    echo "-h, --help    Display this help message"
    exit 0
fi

if curl -s -o /dev/null -w "%{http_code}" https://www.google.com | grep -q '200'; then
    echo "Connected"
  else
    echo "Disconnected"
fi

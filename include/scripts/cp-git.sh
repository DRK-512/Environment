#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "I am too lazy to keep fetching my GitToken to make git pushes"
    echo "Because of that, this command just copies my GitToken so when I do CTRL+V it will paste my git token for me"
    echo ""
    echo "Usage: $0 && git push"
    echo "-h, --help    Display this help message"
    exit 0
fi

# sudo apt install xclip
cat ~/.ssh/GitToken | xclip -selection clipboard

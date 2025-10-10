#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script is meant to act as the grep -r command but for pptx files"
    echo "Since each powerpoint file is essentially a zip file, you can extract them and search their contents"
    echo "So that is what this script does, it searches for some sort of text in pptx files"
    echo ""
    echo "Usage: $0 <search_text> <directory>"
    echo "-h, --help    Display this help message"
    exit 0
fi

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <search_text> <directory>"
    exit 1
fi

SEARCH_TEXT=$1
DIRECTORY=$2

# Iterate over each .pptx file in the directory
for PPTX_FILE in "$DIRECTORY"/*.pptx; do
    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)

    # Unzip the pptx file into the temporary directory
    unzip -q "$PPTX_FILE" -d "$TEMP_DIR"

    # Search for the text within the extracted XML files
    if grep -q -r "$SEARCH_TEXT" "$TEMP_DIR"; then
        echo "Found in $PPTX_FILE"
        grep -r "$SEARCH_TEXT" "$TEMP_DIR"
    fi

    # Clean up the temporary directory
    rm -rf "$TEMP_DIR"
done


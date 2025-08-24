#!/bin/sh
ERR="\e[31m"
EC="\e[0m"

# Function to display usage instructions
usage() {
  echo "Usage: $0 [-d directory] 'old_string' 'new_string'"
  echo "  -d directory: Specify the directory to search in (default: current directory)."
  echo "  'old_string': The string to be replaced."
  echo "  'new_string': The string to replace with."
  exit 1
}

# Default directory is the current directory.
DIR="."

# Parse command-line arguments
while getopts "d:" opt; do
  case $opt in
    d)
      DIR="$OPTARG"
      ;;
    \?)
      echo "${ERR}ERROR:Invalid option: -$OPTARG${EC}" >&2
      usage
      ;;
    :)
      echo "${ERR}ERROR:Option -$OPTARG requires an argument${EC}" >&2
      usage
      ;;
  esac
done

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "${ERR}ERROR: Directory ${DIR} does not exist${EC}"
    exit 1
fi

# Shift the arguments to remove the processed options
shift $((OPTIND - 1))

# Check if the correct number of arguments are provided
if [ $# -ne 2 ]; then
    echo "${ERR}ERROR: Missing old_string or new_string${EC}"
    usage
fi

old_string="$1"
new_string="$2"

# Find all files and perform the replacement using sed directly
find ${DIR} -type f -print0 | xargs -0 sed -i "s/$old_string/$new_string/g"

echo "Replacement completed."

exit 0

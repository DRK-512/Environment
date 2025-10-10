#!/bin/bash
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "WARNING: This only works in a Virtual Machine"
    echo "This script mounts the share drive for a VM"
    echo "This was tested utilizing VM Workstation 17"
    echo ""
    echo "Usage: $0"
    echo "-h, --help    Display this help message"
    exit 0
fi

sudo vmhgfs-fuse .host:/ /mnt/hgfs/ -o allow_other -o uid=1000

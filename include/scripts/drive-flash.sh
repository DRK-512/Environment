#!/bin/bash

source $(dirname "$(realpath "$0")")/config.sh

# Check if the correct number of arguments is provided
[ "$#" -ne 2 ] && log_error "Usage: $0 <path-to-iso> <target-drive>"

ISO_PATH=$1
TARGET_DRIVE=$2

# Check if the ISO file exists and ends with .iso
[[ ! -f "$ISO_PATH" || "${ISO_PATH##*.}" != "iso" ]] && log_error "Error: $ISO_PATH is not a valid ISO file."

# Check if the target drive exists
[[ ! -b "$TARGET_DRIVE" ]] && "Error: $TARGET_DRIVE is not a valid block device."

# Unmount the drive
echo "Unmounting $TARGET_DRIVE..."
ALL_DRIVE="${TARGET_DRIVE}*"
sudo umount ${ALL_DRIVE}

# Flash the ISO file to the target drive
echo "Flashing $ISO_PATH to $TARGET_DRIVE..."
# I added the oflag=sync to make sure the data is written synchronously to the drive
sudo wipefs --all "$TARGET_DRIVE"
(echo g; echo w) |  sudo fdisk $TARGET_DRIVE
sudo dd if="$ISO_PATH" of="$TARGET_DRIVE" bs=1M status=progress oflag=sync

# Check if the dd command succeeded
if [ $? -eq 0 ]; then
  log_success "Flash complete!"
else
  log_error "Error: Flashing failed."
fi

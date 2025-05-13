#!/bin/bash

# Define remote server details
REMOTE_USER="asantos"
REMOTE_HOST="146.193.44.106"
REMOTE_DIR="~/riscv"  # Destination directory

# Find any .bin file in the current directory (assuming only one)
BIN_FILE=$(ls *.bin 2>/dev/null | head -n 1)

# Check if a .bin file exists
if [ -z "$BIN_FILE" ]; then
    echo "No .bin file found in the current directory."
    exit 1
fi

# Transfer the file using scp
scp "$BIN_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"

# Check if scp was successful
if [ $? -eq 0 ]; then
    echo "File $BIN_FILE successfully transferred to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR/"
else
    echo "File transfer failed."
fi


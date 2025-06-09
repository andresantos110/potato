#!/bin/bash

# Find any .bin file in the current directory (assuming only one)
BIN_FILE=$(ls *.bin 2>/dev/null | head -n 1)

# Check if a .bin file exists
if [ -z "$BIN_FILE" ]; then
    echo "No .bin file found in the current directory."
    exit 1
fi

# Run the command using the found .bin file
cat "$BIN_FILE" /dev/zero | head -c128k | pv -s 128k -L 14400 > /dev/ttyUSB1


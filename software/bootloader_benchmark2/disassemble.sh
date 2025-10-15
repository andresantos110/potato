#!/bin/bash

# Find all .elf files in current directory and subdirectories
find . -type f -name "*.elf" | while read -r ELF_FILE; do
    # Get the base name without path or extension
    BASENAME=$(basename "$ELF_FILE" .elf)
    # Generate the output filename in the same directory as the ELF
    DISASM_FILE="$(dirname "$ELF_FILE")/${BASENAME}_disassembly.txt"

    echo "Disassembling $ELF_FILE -> $DISASM_FILE"
    riscv32-unknown-elf-objdump -d -M no-aliases "$ELF_FILE" > "$DISASM_FILE"
done

echo "✅ Disassembly complete."


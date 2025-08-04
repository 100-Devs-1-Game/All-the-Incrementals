#!/bin/bash

# Set the target directory
TARGET_DIR="."

# Convert all .png files to .webp
for file in "$TARGET_DIR"/*.png; do
    # Skip if no .png files are found
    [ -e "$file" ] || continue

    # Get filename without extension
    filename=$(basename -- "$file")
    name="${filename%.*}"

    # Convert to .webp
    cwebp -q 80 "$file" -o "$TARGET_DIR/$name.webp"
done

# Convert all .jpg files to .webp
for file in "$TARGET_DIR"/*.png; do
    # Skip if no .jpg files are found
    [ -e "$file" ] || continue

    # Get filename without extension
    filename=$(basename -- "$file")
    name="${filename%.*}"

    # Convert to .webp
    cwebp -q 80 "$file" -o "$TARGET_DIR/$name.webp"
done

#!/bin/bash

PROJECT_FILE="src/project.godot"

# Check if already present
if grep -q "version_control" "$PROJECT_FILE"; then
  echo "version_control already present in $PROJECT_FILE"
  exit 0
fi

# Append the block to the file
cat <<EOL >> "$PROJECT_FILE"

[editor]

version_control/plugin_name="GitPlugin"
version_control/autoload_on_startup=true
EOL

echo "Added block to $PROJECT_FILE"

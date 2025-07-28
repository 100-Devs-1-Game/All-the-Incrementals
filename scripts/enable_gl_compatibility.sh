#!/bin/bash

PROJECT_FILE="src/project.godot"

# Check if already present
if grep -q "rendering_method" "$PROJECT_FILE"; then
  echo "Rendering method already present in $PROJECT_FILE"
  exit 0
fi

# Append the block to the file
cat <<EOL >> "$PROJECT_FILE"

[rendering]

renderer/rendering_method="gl_compatibility"
renderer/rendering_method.mobile="gl_compatibility"
EOL

echo "Added rendering method block to $PROJECT_FILE"

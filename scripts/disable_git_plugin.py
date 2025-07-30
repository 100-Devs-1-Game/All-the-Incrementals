#!/usr/bin/env python3

PROJECT_FILE = "src/project.godot"

BLOCK = [
    "\n",
    "[editor]\n",
    "\n",
		'version_control/plugin_name="GitPlugin"\n',
		'version_control/autoload_on_startup=true\n'
]

with open(PROJECT_FILE, "r", encoding="utf-8", newline="\n") as f:
    lines = f.readlines()

result = []
i = 0
while i < len(lines):
    # Check if block matches starting at line i
    if lines[i:i+len(BLOCK)] == BLOCK:
        i += len(BLOCK)  # skip the block entirely
    else:
        result.append(lines[i])
        i += 1

with open(PROJECT_FILE, "w", encoding="utf-8", newline="\n") as f:
    f.writelines(result)

print(f"Removed exact block from {PROJECT_FILE} if present.")

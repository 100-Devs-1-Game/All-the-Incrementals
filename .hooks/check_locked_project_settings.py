#!/usr/bin/env python3
import os
import re
import sys
import subprocess

#!/usr/bin/env python3
import sys

# List of settings that should not appear in project.godot
LOCKED_KEYS = [
    "rendering_method",
    # Add more locked keys here if needed
]

def check_locked_keys_absent(path: str) -> bool:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return False

    has_violation = False
    for key in LOCKED_KEYS:
        if key in content:
            print(f"[ERROR] '{path}' should NOT contain locked key '{key}'. Please remove or revert it.")
            has_violation = True

    return not has_violation

def main():
    paths = sys.argv[1:]
    success = True

    for path in paths:
        if path.endswith("project.godot"):
            if not check_locked_keys_absent(path):
                success = False

    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())

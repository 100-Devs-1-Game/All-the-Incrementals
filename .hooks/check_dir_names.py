#!/usr/bin/env python3
import sys
import os
import re

SNAKE_CASE_REGEX = re.compile(r'^[\.a-z0-9_]+$')

def is_snake_case(name):
    return bool(SNAKE_CASE_REGEX.fullmatch(name))

def main():
    # Paths passed by pre-commit (filtered by exclude)
    paths = sys.argv[1:]
    #print(paths)
    invalid_dirs = set()

    for path in paths:
        #print(path)
        # Get all directory parts in the path
        # Normalize path separators, skip leading './'
        parts = os.path.normpath(path).split(os.sep)

        # Ignore the filename (last part) if it's a file
        #if os.path.isfile(path) or ('.' in parts[-1]):
        #    parts = parts[:-1]

        # Check each directory in the path
        for part in parts:
            #print(part)
            if not is_snake_case(part):
                invalid_dirs.add(part)

    if invalid_dirs:
        print("❌ These directory or file names are NOT snake_case:")
        for d in sorted(invalid_dirs):
            print(f"  - {d}")
        return 1

    #print("✅ All checked directory or file names are snake_case.")
    return 0

if __name__ == "__main__":
    sys.exit(main())


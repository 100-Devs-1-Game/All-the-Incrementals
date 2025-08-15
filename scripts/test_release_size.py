import sys
from pathlib import Path

ITCH_IO_MAX_SIZE_MB_PER_FILE = 200 * 1024 * 1024  # Maximum size for itch.io release in MB per file
ITCH_IO_MAX_SIZE_MB = 500 * 1024 * 1024  # Maximum size for itch.io release in MB total

def test_release_size(build_directory: Path) -> None:
    found_large_files = False
    total_size = 0
    for file in build_directory.glob("*"):
        print(file.stat().st_size, file.name)
        total_size += file.stat().st_size
        if file.stat().st_size > ITCH_IO_MAX_SIZE_MB_PER_FILE:  # 200 MB
            print(f"ERROR: {file.name} exceeds 100 MB with size {file.stat().st_size / (1024 * 1024):.2f} MB")
            found_large_files = True
    if found_large_files:
        print("ERROR: One or more files exceed the maximum size for itch.io releases.")
        sys.exit(1)
    if total_size > ITCH_IO_MAX_SIZE_MB:  # 500 MB
        print(f"ERROR: Total size of files exceeds 500 MB with total size {total_size / (1024 * 1024):.2f} MB")


if __name__ == "__main__":
    test_release_size(Path(sys.argv[1]))

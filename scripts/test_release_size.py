import sys
from pathlib import Path

ITCH_IO_MAX_SIZE_MB = 100 * 1024 * 1024  # Maximum size for itch.io release in MB

def test_release_size(build_directory: Path) -> None:
    found_large_files = False
    for file in build_directory.glob("*"):
        if file.stat().st_size > ITCH_IO_MAX_SIZE_MB:  # 100 MB
            print(f"ERROR: {file.name} exceeds 100 MB with size {file.stat().st_size / (1024 * 1024):.2f} MB")
            found_large_files = True

    if found_large_files:
        print("ERROR: One or more files exceed the maximum size for itch.io releases.")
        sys.exit(1)


if __name__ == "__main__":
    test_release_size(Path(sys.argv[1]))

#!/usr/bin/env python3
"""
Godot 4 pre-commit hook for validating UIDs and resource paths.

This script checks:
1. Everything has a UID assigned
2. No duplicate UIDs exist in the project
3. All "res://" text paths are valid and exist
4. All "uid://" text paths are valid and exist

PLS BLAME CLAUDE, I ONLY MADE IT WORK 😭
"""

import os
import re
import sys
import time
from pathlib import Path
from typing import Dict, Set, List, Tuple, Optional
from collections import defaultdict


class GodotValidator:
    def __init__(self, project_root: str, excluded_dirs: Set[str] = None):
        self.project_root = Path(project_root)
        self.uid_to_path: Dict[str, str] = {}
        self.path_to_uid: Dict[str, str] = {}
        self.duplicate_uids: Dict[str, List[str]] = defaultdict(list)
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.excluded_dirs = excluded_dirs or {'addons', 'builds', '.godot', '.git', 'node_modules', '__pycache__', '.venv'}

        # Regex patterns
        # UID definition in .tscn
        self.scene_uid_pattern = re.compile(
            r'\[gd_scene[^]]*uid="(uid://[^"]*)"[^]]*\]'
        )
        # UID definition in .tres
        self.resource_uid_pattern = re.compile(
            r'\[gd_resource[^]]*uid="(uid://[^"]*)"[^]]*\]'
        )
        # UID definition in .uid
        self.uid_file_pattern = re.compile(r'^(uid://[a-z0-9]+)$', re.MULTILINE)
        # UID definition in .import
        self.import_uid_pattern = re.compile(r'^uid="(uid://[^"]*)"', re.MULTILINE)

        # Patterns for static paths only (not dynamically constructed)
        self.res_path_pattern = re.compile(r'"(res://(?!\.godot)[^"{}%]*)"')  # Exclude paths with format strings
        self.uid_path_pattern = re.compile(r'"(uid://[^"]*)"')

        # External resources must have a valid UID and path
        self.ext_resource_block_pattern = re.compile(
            r'\[ext_resource([^]]*)\]', re.MULTILINE | re.DOTALL
        )

        # Extract individual attributes from ext_resource content
        self.ext_resource_type_pattern = re.compile(r'type="([^"]*)"')
        self.ext_resource_uid_pattern = re.compile(r'uid="(uid://[^"]*)"')
        self.ext_resource_path_pattern = re.compile(r'path="([^"]*)"')

    def scan_project(self):
        """Scan the entire project for UID mappings and validate them."""
        t0 = time.time()
        files = self._get_godot_files()
        print(f"\nScanning Godot project took {time.time() - t0} seconds")

        # First pass: collect all UID mappings
        t0 = time.time()
        self._collect_uid_mappings(files)
        print(f"Collecting UIDs from {len(files)} files took {time.time() - t0} seconds")

        # Second pass: validate all references
        t0 = time.time()
        self._validate_references(files)
        print(f"Validating references took {time.time() - t0} seconds")

        # Check for duplicates
        self._check_duplicate_uids()

        # Sanity check: unique paths and unique UID's should be the same count
        if len(self.uid_to_path) != len(self.path_to_uid):
            self.errors.append(
                f"There are {len(self.path_to_uid)} unique paths and "
                 f"{len(self.uid_to_path)} UID definitions - These should be identical, as each of these paths should have a UID"
            )

        return len(self.errors) == 0

    def _collect_uid_mappings(self, files: List[Path]):
        """Collect all UID to path mappings from the project."""
        for file_path in files:
            if file_path.suffix not in ['.uid', '.tscn', '.tres', '.import']:
                continue

            try:
                with open(file_path, 'r', encoding='utf-8-sig') as f:
                    content = f.read()

                rel_path = str(file_path.relative_to(self.project_root))

                if file_path.suffix == '.uid':
                    self._process_uid_file(file_path, content)
                elif file_path.suffix in ['.tscn', '.tres', '.import']:
                    self._process_resource_file(file_path, content, rel_path)

            except Exception as e:
                self.errors.append(f"Error reading {file_path}: {e}")

    def _process_uid_file(self, file_path: Path, content: str):
        """Process a .uid file to extract UID mapping."""
        lines = content.strip().split('\n')
        uid_line = lines[0].strip() if lines else ""

        match = self.uid_file_pattern.match(uid_line)

        if not match:
            self.errors.append(f"Invalid UID file format: {file_path} (content: '{uid_line}')")
            return

        uid = match.group(1)
        # UID file corresponds to the file with the same name but different extension
        resource_path = file_path.with_suffix('')

        if not resource_path.exists():
            self.errors.append(f"UID file {file_path} has no corresponding resource file")
            return

        res_path = f"res://{resource_path.relative_to(self.project_root)}"
        self._add_uid_mapping(uid, res_path, str(file_path))

    def _process_resource_file(self, file_path: Path, content: str, rel_path: str):
        """Process resource files to extract UID mappings."""
        res_path = f"res://{rel_path}"

        # Check for import file UID (asset UIDs are defined in .import files)
        if file_path.suffix == '.import':
            import_match = self.import_uid_pattern.search(content)
            if import_match:
                uid = import_match.group(1)
                # Import files define UIDs for their corresponding asset
                asset_path = file_path.with_suffix('')  # Remove .import extension
                if asset_path.exists():
                    asset_res_path = f"res://{asset_path.relative_to(self.project_root)}"
                    self._add_uid_mapping(uid, asset_res_path, str(file_path))
                else:
                    self.errors.append(f".import file {file_path} has no corresponding asset file")

        # Check for scene UID
        elif file_path.suffix == '.tscn':
            scene_match = self.scene_uid_pattern.search(content)
            if scene_match:
                uid = scene_match.group(1)
                self._add_uid_mapping(uid, res_path, str(file_path))
            else:
                self.errors.append(f".tscn file {file_path} has no UID")

        # Check for resource UID
        elif file_path.suffix == '.tres':
            resource_match = self.resource_uid_pattern.search(content)
            if resource_match:
                uid = resource_match.group(1)
                self._add_uid_mapping(uid, res_path, str(file_path))
            else:
                self.errors.append(f".tres file {file_path} has no UID")

    def _validate_ext_resources(self, file_path: Path, content: str):
        """Validate all ext_resource blocks in a file."""
        for match in self.ext_resource_block_pattern.finditer(content):
            ext_resource_content = match.group(1)
            line_number = content[:match.start()].count('\n') + 1

            # Extract attributes
            type_match = self.ext_resource_type_pattern.search(ext_resource_content)
            uid_match = self.ext_resource_uid_pattern.search(ext_resource_content)
            path_match = self.ext_resource_path_pattern.search(ext_resource_content)

            resource_type = type_match.group(1) if type_match else None
            uid = uid_match.group(1) if uid_match else None
            path = path_match.group(1) if path_match else None

            # TODO: should we validate the type?
            if not resource_type:
                self.errors.append(
                    f"{file_path.relative_to(self.project_root)}:{line_number}: "
                    f"Missing type for ext_resource '{match.group()}'"
                )

            # We don't need to validate that the path is real because that is done in a later step
            if not path:
                self.errors.append(
                    f"{file_path.relative_to(self.project_root)}:{line_number}: "
                    f"Missing path for ext_resource '{match.group()}'"
                )

            # We don't need to validate that the UID is real because that is done in a later step
            if not uid:
                self.errors.append(
                    f"{file_path.relative_to(self.project_root)}:{line_number}: "
                    f"Missing UID for ext_resource '{match.group()}'"
                )

            # Validate that the UID->path mapping is consistent
            if uid and path and uid in self.uid_to_path:
                expected_path = self.uid_to_path[uid]
                if expected_path != path:
                    self.errors.append(
                        f"{file_path.relative_to(self.project_root)}:{line_number}: "
                        f"UID '{uid}' represents '{expected_path}', but the ext_resource thinks it's '{path}'"
                    )

    def _add_uid_mapping(self, uid: str, path: str, source: str):
        """Add a UID to path mapping, tracking duplicates."""
        if uid in self.uid_to_path:
            if self.uid_to_path[uid] != path:
                self.duplicate_uids[uid].extend([self.uid_to_path[uid], path])
        else:
            self.uid_to_path[uid] = path

        if path not in self.path_to_uid:
            self.path_to_uid[path] = uid

    def _validate_references(self, files: List[Path]):
        """Validate all res:// and uid:// references in the project."""

        for file_path in files:
            # these files don't reference other UID's
            #if file_path.suffix in ['.uid', '.import']:
            #    continue

            try:
                with open(file_path, 'r', encoding='utf-8-sig') as f:
                    content = f.read()

                self._validate_ext_resources(file_path, content)
                self._validate_res_paths(file_path, content)
                self._validate_uid_paths(file_path, content)
                self._check_file_has_uid(file_path, content)

            except Exception as e:
                self.errors.append(f"Error validating {file_path}: {e}")

    def _validate_res_paths(self, file_path: Path, content: str):
        """Validate all res:// paths in a file."""
        for match in self.res_path_pattern.finditer(content):
            res_path = match.group(1)

            # Skip paths that look like they're constructed dynamically
            if any(marker in res_path for marker in ['{', '}', '%s', '%d', '%f']):
                continue

            # Convert res:// path to actual file path
            actual_path = self.project_root / res_path[6:]  # Remove "res://"

            if not actual_path.exists():
                self.errors.append(
                    f"{file_path.relative_to(self.project_root)}: "
                    f"The file '{res_path}' does not exist"
                )

    def _validate_uid_paths(self, file_path: Path, content: str):
        """Validate all uid:// paths in a file."""
        for match in self.uid_path_pattern.finditer(content):
            uid_path = match.group(1)

            if uid_path not in self.uid_to_path:
                self.errors.append(
                    f"{file_path.relative_to(self.project_root)}: "
                    f"The UID '{uid_path}' does not exist"
                )

    def _check_file_has_uid(self, file_path: Path, content: str):
        """Check if files that should have UIDs actually have them."""
        if file_path.suffix not in ['.tscn', '.tres']:
            return

        res_path = f"res://{file_path.relative_to(self.project_root)}"

        # Check if file has a UID in its content or a corresponding .uid file
        has_inline_uid = (self.scene_uid_pattern.search(content) or
                         self.resource_uid_pattern.search(content))
        has_uid_file = file_path.with_suffix(file_path.suffix + '.uid').exists()

        if not has_inline_uid and not has_uid_file:
            self.errors.append(
                f"{file_path.relative_to(self.project_root)}: "
                f"The file has no UID defined"
            )

    def _check_duplicate_uids(self):
        """Check for duplicate UIDs in the project."""
        for uid, paths in self.duplicate_uids.items():
            if len(paths) > 1:
                self.errors.append(
                    f"Duplicate UID {uid} found in: {', '.join(set(paths))}"
                )

    def _get_godot_files(self) -> List[Path]:
        """Get all relevant Godot files in the project."""
        # Include more file types that can contain UIDs and resource references
        extensions = {'.tscn', '.tres', '.gd', '.cs', '.uid', '.json', '.cfg', '.import', '.godot'}
        files = []

        for ext in extensions:
            files.extend(self.project_root.rglob(f'*{ext}'))

        # Filter out files in excluded directories
        return [f for f in files if not any(part in self.excluded_dirs for part in f.parts)]

    def print_results(self):
        """Print validation results."""
        if self.errors:
            print("\nErrors:")
            for error in self.errors:
                print(f"  {error}")
            print(f"\nFound {len(self.errors)} error(s)")
        else:
            print("\nAll UID and path validations passed!")

        print(f"Found {len(self.uid_to_path)} unique UIDs")


def main():
    """Main entry point for the pre-commit hook."""
    import argparse

    start_time = time.time()

    parser = argparse.ArgumentParser(description='Validate Godot 4 UIDs and resource paths')
    parser.add_argument('--exclude', action='append', help='Directories to exclude (can be used multiple times)')
    parser.add_argument('--project-root', help='Path to Godot project root (auto-detected if not specified)')
    args = parser.parse_args()

    # Find the project root (look for project.godot file)
    if args.project_root:
        project_root = Path(args.project_root)
    else:
        current_dir = Path.cwd()
        project_root = None

        # Search current directory and parents for project.godot
        search_paths = [current_dir] + list(current_dir.parents)
        for parent in search_paths:
            if (parent / 'project.godot').exists():
                project_root = parent
                break

        # Also check if we're in a subdirectory and project.godot is in a sibling directory
        if not project_root and current_dir.name in ['.hooks', 'scripts', 'tools']:
            # Look in parent's subdirectories
            parent = current_dir.parent
            for subdir in parent.iterdir():
                if subdir.is_dir() and (subdir / 'project.godot').exists():
                    project_root = subdir
                    break

    if not project_root or not project_root.exists():
        print("Error: Could not find project.godot file. Use --project-root to specify the location.")
        sys.exit(1)

    print(f"Found Godot project at: {project_root}")

    excluded_dirs = set(args.exclude) if args.exclude else None
    validator = GodotValidator(str(project_root), excluded_dirs)
    success = validator.scan_project()
    validator.print_results()

    print(f"Finished in {time.time() - start_time} seconds")

    if not success:
        sys.exit(1)

    print("\nSuccessfully validated")


if __name__ == '__main__':
    main()

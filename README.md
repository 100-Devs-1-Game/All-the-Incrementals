# 100 Devs - 1 Game - All The Incrementals

Make sure to read the contributors guide before contributing.

Required Software:
[Godot v4.4.1](https://godotengine.org/download/)
[Github Desktop](https://desktop.github.com/download/)

## Development Setup

After cloning, enter the project folder and set up requirements and environment:

Linux:

```
./setup.sh
```

Windows:


```
pip install -r requirements.txt
pre-commit install
git lfs install
```

Recommended software:
- Editor: [VSCode](https://code.visualstudio.com/) full IDE with advanced functionality compared to the Godot Editor, but needs to be configured properly
  - With the [GDScript Formatter and Linter Extension](https://marketplace.visualstudio.com/items?itemName=EddieDover.gdscript-formatter-linter)


## Our new backend

The file server may prompt you to provide credentials now, if you upload anything to this Repository.

<img width="461" height="358" alt="image" src="https://github.com/user-attachments/assets/0949377f-4feb-4d35-a3ed-942a1954d103" />

Please check the discord server for the required credentials, this is not your github login

### Guides:

:closed_book: [Beginner Guide to Godot and Git](https://blog.paulhartman.dev/100-dev-setup)

:closed_book: [From Programming task assignment to integration](docs/coding_guide.md)

:closed_book: [Contributors Guide](docs/contributing.md) [ [TL;DR](docs/contributing_tldr.md) ]

### Project specific Guidelines ( Programming )

- We are using a global Autoload Event/Signal Bus where all `signals` that aren't purely for intra-module communication will reside. If possible try to design your modules in away that they only communicate through those global signals with the outside.
- We are using Formatter and Linter plugins that will automatically re-format your code or point out potential Errors when you save your Scripts. This may cause some confusion and also trigger the "Newer Files on Disk" Dialog in the Godot Editor, where you can choose "Reload from Disk"
- It's against convention to use `_variable` for variables that *are not* unused. Use `p_variable` instead if you run into issues, eg. in `_init()`
- We discourage the use of `await`, `set_deferred()` and `call_deferred()` unless you know exactly what you are doing and what the implications are. Best to leave a comment above that line to inform Code Reviewers why you think it's safe to use in your case.

### Core Addons

- [GuT](https://github.com/bitwes/Gut): For Unit testing
- [DebugDraw3d](https://github.com/DmitriySalnikov/godot_debug_draw_3d): It's good
- [Format-On-Save](https://github.com/ryan-haskell/gdformat-on-save): Auto-formatting
- [Godot-Logger](https://github.com/KOBUGE-Games/godot-logger): Logs
- [FMod-extension](https://github.com/utopia-rise/fmod-gdextension): Audio extension

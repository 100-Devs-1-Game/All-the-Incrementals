# 100 Devs - 1 Game - All The Incrementals

A collaborative game jam project. A game of ever-expanding minigames.

**What happens when 100 devs come together to make 1 game in a game jam?** Join us on [discord](https://discord.gg/UHN4AjMw4d) to find out!

## Getting Started

Play the game! You can download the Windows, Mac, iOS, Android, or Linux binaries on the [releases page](https://github.com/100-Devs-1-Game/All-the-Incrementals/releases) or play the game on your browser at [itch.io](https://itch.io/jam/100-devs-1-game-collaborative-godot-game-jam).

If you want to get involved, join the [discord](https://discord.gg/UHN4AjMw4d) and check out one of the following sections:

- [How to contribute code](#how-to-contribute-code)
- [How to contribute art, sound, and music](#how-to-contribute-art-and-soundmusic)
- [How to contribute game ideas](#how-to-contribute-game-ideas)
- [How to contribute testing and bug reports](#how-to-contribute-qa-testing-and-bug-reports)

## How to contribute code:

1. Read the contributors guides and review [project-specific guidelines](#project-specific-guidelines).
    - :closed_book: [Beginner Guide to Godot and Git](https://blog.paulhartman.dev/100-dev-setup)
    - :closed_book: [From Programming task assignment to integration](docs/coding_guide.md)
    - :closed_book: [Contributors Guide](docs/contributing.md) [ [TL;DR](docs/contributing_tldr.md) ]
2. [Request and gain access](#access-requests-for-contributors) (github, lfs, google drive).
3. Clone the repo, and run the setup scripts:
    1. Linux:
    ```
    ./setup.sh
    ```
    1. Windows:
    ```
    pip install -r requirements.txt
    pre-commit install
    git lfs install
    ```
4. Optional recommended software:
    - Editor: [VSCode](https://code.visualstudio.com/) full IDE with advanced functionality compared to the Godot Editor, but needs to be configured properly with the [GDScript Formatter and Linter Extension](https://marketplace.visualstudio.com/items?itemName=EddieDover.gdscript-formatter-linter)
5. Review GDD.
6. Assign tasks on coding kanban board to yourself.
7. Implement and push a branch, create a PR.
8. Get it reviewed, revise if necessary.
9. Get it merged.
10. Rinse and repeat!

### Project-specific Guidelines

- We are using a global Autoload Event/Signal Bus where all `signals` that aren't purely for intra-module communication will reside. If possible try to design your modules in away that they only communicate through those global signals with the outside
- We are using Formatter and Linter plugins that will automatically re-format your code or point out potential Errors when you save your Scripts. This may cause some confusion and also trigger the "Newer Files on Disk" Dialog in the Godot Editor, where you can choose "Reload from Disk"
- It's against convention to use `_variable` for variables that *are not* unused. Use `p_variable` instead if you run into issues, eg. in `_init()`
- We discourage the use of `await`, `set_deferred()` and `call_deferred()` unless you know exactly what you are doing and what the implications are. Best to leave a comment above that line to inform Code Reviewers why you think it's safe to use in your case
- Make sure to prefix private variables/functions with an "_" so there's no confusion when interfacing with other Modules which properties should and shouldn't be accessed directly
- We will use Tabs for indentation ( it's being enforced by our Formatter )
- We will store all assets in `src/assets/` and all autoloads/singletons in `src/global/`
- Everybody can merge PRs when they have been approved, not just the author
- Code reviewers will prioritize speed over depth, unless the PR is labeled "critical review" or it modifies the code of multiple, independent Modules

### Core Addons

- [GuT](https://github.com/bitwes/Gut): For Unit testing
- [DebugDraw3d](https://github.com/DmitriySalnikov/godot_debug_draw_3d): It's good
- [Format-On-Save](https://github.com/ryan-haskell/gdformat-on-save): Auto-formatting
- [Godot-Logger](https://github.com/KOBUGE-Games/godot-logger): Logs
- ~~[FMod-extension](https://github.com/utopia-rise/fmod-gdextension): Audio extension~~ | removed for now, doesn't allow web builds

## How to contribute art and sound/music:

1. [Request and gain access](#access-requests-for-contributors) (google drive).
1. Read the theme, art and sound guidelines in the GDD.
1. Assign tasks on the art or sound kanban board to yourself.
1. Upload the asset to the Google drive.
1. Mark task as done (submitted).
1. Rinse and repeat!

## How to contribute game ideas:

1. [Request and gain access](#access-requests-for-contributors) (google drive).
1. Read the GDD.
1. Join the [discord](https://discord.gg/UHN4AjMw4d) and talk about what you want to see.
1. Get consensus.
1. Update the GDD.
1. Work with a coder to break up the idea into tasks onto the project board to be picked up by the art, sound, and coding teams.
1. Rinse and repeat!

## How to contribute QA testing and bug reports:

1. Play the game ([downloads](https://github.com/100-Devs-1-Game/All-the-Incrementals/releases) or in your browser at [itch.io](https://itch.io/jam/100-devs-1-game-collaborative-godot-game-jam)).
1. Find bugs and [create a bug report ticket here](https://github.com/100-Devs-1-Game/All-the-Incrementals/issues/new).
1. Describe the issue as best as possible.
1. Rinse and repeat!

## Access requests for contributors

### Google Drive for Assets, Game Design Doc, etc. - For Everyone

To gain access to the Google Drive where we have assets, game design docs, and other project files, follow the google drive link on the `#links` channel on discord.

An access request window should appear automatically when accessing the link.

If your Google account ID/email doesn't match your discord username, then please send a message to `@niconorsk` with your information so it can be correlated.

### GitHub Repo Access - For Coders

To gain access to GitHub, request access in the `#request-github-access` channel on discord.

### Git LFS - For Coders

The file server may prompt you to provide credentials now, if you upload anything to this Repository.
This is only required if you're working directly with git and the repo.

<img width="200" alt="image" src="https://github.com/user-attachments/assets/0949377f-4feb-4d35-a3ed-942a1954d103" />

To gain access (LFS credentials), check the `#links` channel on discord. *This is not your github login!*

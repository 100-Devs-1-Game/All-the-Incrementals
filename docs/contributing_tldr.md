# 🧠 TL;DR: Contributing Guide for Beginners

## :inbox_tray: Opening an Issue

- Use the latest version of the main branch before reporting.
- Search existing issues to avoid duplicates.
- Format your code with `` backticks. One for a line, 3 for a block
  
`Codeline`

```
Code
block
```

## :repeat: Submitting Pull Requests

- Submit **small, focused** PRs.
- Don't refactor unrelated code.
- Discuss big changes first.
- If necessary update tests.
- Fix any CI/test failures ASAP, you may have to wait for all automated test actions to complete.

## :memo: Commits

- We never commit to the `main` branch directly.
- Subject line: 50 chars max, capitalized, no period, imperative: "Fix bug", not "Fixes bug" or "Fixed bug".
- Leave a blank line between subject and body. Most GUIs will do that automatically.
- Use the body and explain **why** in the body, not just **what**.

## :nail_care: Coding Style

- Follow the [official GDScript styleguide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- Use spaces for indentation, not tabs.

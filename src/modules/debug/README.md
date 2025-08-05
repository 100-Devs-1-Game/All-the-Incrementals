# What is the DebugPopup?

The DebugPopup is a node you can add to your game scene to act as a helper
window to execute various functions without completing them in the game. This
can help as a shortcut for debugging and testing.

The idea is to link various functions defined in your scene to buttons that
appear on the DebugPopup.

# How to use the DebugPopup

1. Add the DebugPopup to your scene.
1. Go to the Inspector for DebugPopup and add elements to the
   Debug Functions array. Each element is a DebugButton that will be used
   to call a debug function in the parent scene with optional hotkey.
1. Set the name of the parent function to call. Set a hotkey.
1. Run your scene.
1. By default, the DebugPopup is invisible.
1. You can press any of the hotkeys to execute a function.
1. Press the hotkey (default X) to display the DebugPopup.
1. Click your debug button and ensure that it executes the function
   you defined in the parent scene.

# Extending DebugPopup with your own shortcuts

1. Take a look at debug_minigame_upgrade.gd and tscn files.
1. Take a look at the example minigame.
1. The DebugMinigameUpgrade node is added to the scene, and the export variable
   for DebugPopup is linked accordingly.
1. Using the DebugPopup's public functions `get_tree_root()`, `link_callable()`,
   and `register_hotkey()` you can add more items to the tree.

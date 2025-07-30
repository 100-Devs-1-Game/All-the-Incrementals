# What is the DebugPopup?

The DebugPopup is a node you can add to your game scene to act as a helper
window to execute various functions without completing them in the game. This
can help as a shortcut for debugging and testing.

The idea is to link various functions of the name `debug_<name>()` defined in
your scene to buttons that appear on the DebugPopup.

# How to use the DebugPopup

1. Add the DebugPopup to your scene.
1. Go to the Inspector for DebugPopup and add elements to the
   Debug Functions array. Each element is a string that will be used
   to call a debug function in the parent scene.
1. Define a function debug_<name> where <name> is what you specified.
1. Run your scene.
1. By default, the DebugPopup is invisible.
1. Press the hotkey (default X) to display the DebugPopup.
1. Click your debug button and ensure that it executes the function
   you defined in the parent scene.

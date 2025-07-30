The `Placeholder` scene is used as a placeholder for unfinished development.
You can add temporary buttons to the placeholder scene to simulate various
actions that can be performed in the scene (eventually).

*How to use the Placeholder*

Add the Placeholder as a child of a scene. In the Inspector tab for the child
Placeholder, set the `For Text` to be a short text description of the scene that
this is a placeholder for, and set 0 or more temporary shortcut buttons.

To add buttons, click `Add Element` to the Buttons property, change `<empty>`
to `New PlaceholderButton`, click the element, and set the `Label` to be what
you want the button label to be, and `Scene Path` to be the full
`res://<target>.tscn` string path that should be loaded upon clicking the button.

You can easily copy-and-paste from the Godot FileSystem by using Shift-Ctrl-C
after selecting the .tscn file, and then Ctrl-V to paste it into `Scene Path`.

*What happens when I make the actual scene?*

You should delete the Placeholder once you have started work on the scene. The
final game project should not have any more Placeholders anywhere.

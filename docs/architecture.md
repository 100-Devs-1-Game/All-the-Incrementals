# Game Architecture

Some of the code and design decisions and architecture may need a bit of extra explanation so we document it here.
Some people who are trying to understand the code base for the first time may benefit from reading this as they
go through the project.

## How does the game start?

The initial scene is in `res://modules/main/main.tscn` which launches the splash screens and leads to the main menu.

## What are the modules in the `res://modules/` folder?

Each module is a part of the game that is somewhat contained to doing one thing. However, there is no strict definition
and it's purpose is to provide a way of organizing the code.

## What is the `DebugPopup`?

The DebugPopup is a Node that can be dropped into any scene and offer a quick way to perform debugging-only related
tasks associated with your scene. It also acts as a placeholder for many scenes. The shortcuts are displayed as a tree
and you can easily add additional shortcuts relevant to your scene. Each item is a DebugButton type, and at a very
basic level, simply lets you specify a function name you want to have run when clicking on the tree item.

## What is the `PopupMenu`?

The PopupMenu provides a popup scene that overlays on the current one showing a game menu. This is triggered by
pressing Escape during the game. It allows you to change settings, quit the game, and other such general functions.

## What is the `BaseMinigame`?

The BaseMinigame is a base class and Node that is extended by every Minigame. It provides functionality that is used
by every minigame, as well as help integrate the Minigame to the rest of the game.

## What is the `MinigameData`?

The MinigameData is a resource that stores essential data used by Minigames. Every Minigame should have a unique
instance of the MinigameData resource type.

## What is the `SharedBaseComponents`?

This is a Node that can be dropped into any scene and provides some basic functionality that will be useful among
a lot of scenes. For example, it adds a DebugPopup as well as a PopupMenu. This makes it easy to manage shared
features all in one place. Minigames should not use this component directly, and should drop in a MinigameSharedComponents
instead.

## What is the `MinigameSharedComponents`?

This is a Node that must be dropped into every Minigame scene and provides shared functionality that will be
used by every Minigame. This also contains a SharedBaseComponents, so there is no need for a Minigame to supply
that separately. This also provides shortcuts for manually executing upgrades for the Minigame.

## Why use Composition for the shared components?

There are trade-offs to other ways of sharing, such as trying to wrap each minigame into a shared parent
Node. One advantage of having the shared component inside of the minigame, is that the minigame can more
appropriately dictate how it wants some of the shared functionality to behave. For example, one of the
things you can do is add additional debugging functions to the DebugPopup. This requires awareness of the
DebugPopup. Trying to avoid "external awareness" of the existence of the DebugPopup by moving that into
a shared parent node adds some complexity (as a tradeoff). It's easier for the minigame to know that such a
component exists and that is a member of the Minigame node as a child to control it's features directly.

We may still change the architecture in the future, but this is the shared component design for now.

## What is the UpgradeTree Editor?

This is a special editor created during this project for editing a skill or ability upgrade tree for use in
the Minigames. For example, the player can upgrade to move faster or function better. It operates on
MinigameData which contains the upgrade tree for the Minigame.

## What is the `EssenceInventory`?

The EssenceInventory is a collection of one or more EssenceStacks. It can be used for the Players Inventory or defining the cost of an Upgrade.

## What is the `EssenceStack`?

An EssenceStack is the amount of a single type of Essence.

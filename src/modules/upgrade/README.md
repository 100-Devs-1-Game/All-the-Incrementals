# Creating a new upgrade

It is recommended to open a MiniGameData resource and use the UpgradeTree editor plugin to manage multiple upgrades and their relationships

## Choosing between manual and automatic management of cost and modifier arrays

When creating a new upgrade, you can choose between:

- manually create the cost_arr and effect_modifier_arr fields in the upgrade
- set base_cost, base_cost_multiplier, base_effect_modifier, effect_modifier_multiplier and have the setters generate the 2 above arrays for you

The former gives you more control but is fiddlier, the latter is quicker but less granular.

A third option is to use the algorithm to construct the initial arrays, reset the base fields to 0, then switch to manually controlling the arrays from there.

## Resource setter gotcha

When you are creating the base_cost, the setter won't automatically be called when you are modifying the nested values of EssenceInventory.
The workaround is to change one of the other files like base_cost_multiplier to force the regeneration.

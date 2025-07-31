extends BaseMinigame

const BRANCH_COLORS = [Color.GREEN, Color.ORANGE]

@onready var hbox: HBoxContainer = %HBoxContainer


func _start() -> void:
	# start recursive display of upgrade layers
	add_upgrade_layer(data.upgrade_tree_root_nodes, 1, Color.BLACK)


func add_upgrade_layer(upgrades: Array[MinigameUpgrade], depth: int, color: Color):
	# determine how deep we are in the tree and choose/create VBox Container
	var vbox: VBoxContainer
	if hbox.get_child_count() < depth:
		vbox = VBoxContainer.new()
		hbox.add_child(vbox)
	else:
		vbox = hbox.get_child(depth - 1)

	# loop through all upgrades in this branch and create a Button for each
	for upgrade in upgrades:
		var button := Button.new()
		button.text = upgrade.name

		# pick a color to differentiate branches
		var branch_color: Color
		if color == Color.BLACK:
			branch_color = BRANCH_COLORS[upgrades.find(upgrade)]
		else:
			branch_color = color
		button.add_theme_color_override("font_color", branch_color)

		vbox.add_child(button)

		# create another recursion for all upgrades unlocked by this upgrade
		if not upgrade.unlocks.is_empty():
			var unlocks: Array[MinigameUpgrade]
			# convert Array type from BaseUpgrade to MinigameUpgrade
			unlocks.assign(upgrade.unlocks)

			add_upgrade_layer(unlocks, depth + 1, branch_color)

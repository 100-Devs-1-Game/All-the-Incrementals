class_name AltarUI
extends CanvasLayer

@onready var grid_container: GridContainer = %GridContainer


func init(element: Altar.Element):
	%"Label Altar".text = str(element, " Altar")


func update(stats: AltarStats):
	var player_state: PlayerState = SaveGameManager.world_state.player_state

	%"Label Stored".text = "Stored: %d" % stats.stored_essence
	%"Label Capacity".text = "Capacity: %d" % stats.capacity
	%"Label Throughput".text = "Throughput: %d" % stats.throughput

	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

	for minigame in stats.minigames:
		var label := Label.new()
		label.text = minigame.display_name
		grid_container.add_child(label)

		label = Label.new()
		label.text = "Avg. Score: %.1f" % player_state.get_average_highscore(minigame)
		grid_container.add_child(label)

		label = Label.new()
		label.text = "* %.2f" % minigame.currency_conversion_factor
		grid_container.add_child(label)

		label = Label.new()
		var amount: float = stats.calc_generated_amount(minigame)
		label.text = "= %d (%.1f)" % [int(amount), amount]
		grid_container.add_child(label)

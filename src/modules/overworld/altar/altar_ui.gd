class_name AltarUI
extends CanvasLayer

var _altar_stats: AltarStats

@onready var current_essence_display: CurrentEssenceDisplay = $Panel/CurrentEssence
@onready var grid_container: GridContainer = %GridContainer


func _ready() -> void:
	EventBus.passive_essence_generation_tick.connect(_on_generation_tick)


func init(stats: AltarStats):
	_altar_stats = stats
	%"Label Altar".text = Altar.Element.keys()[_altar_stats.element] + " Altar"


func update():
	var player_state: PlayerState = SaveGameManager.world_state.player_state

	%"Label Stored".text = "Stored: %d" % _altar_stats.stored_essence
	%"Label Capacity".text = "Capacity: %d" % _altar_stats.capacity
	%"Label Throughput".text = "Throughput: %d" % _altar_stats.throughput

	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

	for minigame in _altar_stats.minigames:
		var button := Button.new()
		button.text = "Play >"
		button.pressed.connect(SceneLoader.start_minigame.bind(minigame))
		grid_container.add_child(button)

		var label := Label.new()
		label.text = minigame.display_name
		grid_container.add_child(label)

		label = Label.new()
		label.text = "Avg. Score: %.1f" % player_state.get_average_minigame_highscore(minigame)
		grid_container.add_child(label)

		label = Label.new()
		label.text = "* %.2f" % minigame.currency_conversion_factor
		grid_container.add_child(label)

		label = Label.new()
		var amount: float = _altar_stats.calc_generated_amount(minigame)
		label.text = "= %d (%.1f)" % [int(amount), amount]
		grid_container.add_child(label)


func _on_leave_pressed() -> void:
	hide()
	EventBus.stop_player_interaction.emit()


func _on_generation_tick():
	if visible:
		assert(_altar_stats != null)
		current_essence_display.refresh_labels()
		update()

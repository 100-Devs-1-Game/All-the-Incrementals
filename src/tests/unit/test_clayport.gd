extends "res://addons/gut/test.gd"


func test_clayport() -> void:
	var overworld = SceneLoader.OVERWORLD_SCENE.instantiate()

	SceneLoader._current_settlement = SceneLoader.CLAYPORT_SETTLEMENT_DATA

	print("Adding child")
	add_child_autofree(overworld)

	print("Simulating")
	gut.simulate(overworld, 10, .1)
	await wait_seconds(1)

	print("Assert")

	overworld.queue_free()

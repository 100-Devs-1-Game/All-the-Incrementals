extends "res://addons/gut/test.gd"


func test_breezekiln() -> void:
	var overworld = SceneLoader.OVERWORLD_SCENE.instantiate()

	SceneLoader._current_settlement = SceneLoader.BREEZEKILN_SETTLEMENT_DATA

	print("Adding child")
	add_child_autofree(overworld)

	print("Simulating")
	gut.simulate(overworld, 10, .1)
	await wait_seconds(1)

	print("Assert")

	overworld.queue_free()

extends "res://addons/gut/test.gd"


func test_shrine() -> void:
	var overworld = SceneLoader.OVERWORLD_SCENE.instantiate()

	SceneLoader._current_settlement = SceneLoader.SHRINE_SETTLEMENT_DATA

	print("Adding child")
	add_child_autofree(overworld)

	var shrine = overworld.settlement_scene_holder_node.get_child(0)

	print("Simulating")
	gut.simulate(overworld, 10, .1)
	await wait_seconds(1)

	print("Assert")
	assert_eq(shrine.name, "Shrine", "todo: replace with real assert")

	overworld.queue_free()

extends "res://addons/gut/test.gd"


func test_breezekiln() -> void:
	var overworld = SceneLoader.OVERWORLD_SCENE.instantiate()

	SceneLoader._current_settlement = SceneLoader.BREEZEKILN_SETTLEMENT_DATA

	print("Adding child")
	add_child_autofree(overworld)

	var breezekiln = overworld.settlement_scene_holder_node.get_child(0)

	print("Simulating")
	gut.simulate(overworld, 10, .1)
	await wait_seconds(1)

	print("Assert")
	assert_ne(breezekiln.fire_cooking_data, null, "no fire cooking minigame data set")
	assert_ne(breezekiln.fire_fighters_data, null, "no fire fighter minigame data set")
	assert_ne(breezekiln.wind_platformer_data, null, "no wind platformer minigame data set")
	assert_ne(breezekiln.wind_rhythm_data, null, "no wind rhythm minigame data set")

	overworld.queue_free()

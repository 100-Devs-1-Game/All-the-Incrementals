extends "res://addons/gut/test.gd"


func test_clayport() -> void:
	var overworld = SceneLoader.OVERWORLD_SCENE.instantiate()

	SceneLoader._current_settlement = SceneLoader.CLAYPORT_SETTLEMENT_DATA

	print("Adding child")
	add_child_autofree(overworld)

	var clayport = overworld.settlement_scene_holder_node.get_child(0)

	print("Simulating")
	gut.simulate(overworld, 10, .1)
	await wait_seconds(1)

	print("Assert")
	assert_ne(clayport.earth_potato_herding_data, null, "no earth potato herding minigame data set")
	assert_ne(clayport.earth_towers_data, null, "no earth towers minigame data set")
	assert_ne(clayport.water_rowing_rapids_data, null, "no water rowing rapids minigame data set")
	assert_ne(clayport.water_target_fishing_data, null, "no water target fishing minigame data set")

	overworld.queue_free()

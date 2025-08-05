extends "res://addons/gut/test.gd"


func test_water_target_fishing_run() -> void:
	var water_target_fishing_data: MinigameData = load(
		"res://modules/minigame/water_target_fishing/data/water_fishing_data.tres"
	)

	var water_target_fishing: WTFMinigame = (
		load("res://modules/minigame/water_target_fishing/water_target_fishing.tscn").instantiate()
	)

	SceneLoader._current_minigame = water_target_fishing_data
	SceneLoader.enable_immediate_play()
	water_target_fishing.data = water_target_fishing_data

	print("Adding child")
	add_child_autofree(water_target_fishing)

	print("Simulating")
	WTFGlobals.minigame = water_target_fishing
	gut.simulate(water_target_fishing, 10, .1)
	await wait_seconds(3)

	print("Assert")
	assert_gt(water_target_fishing._distance_travelled, 1000.0, "distance > 1000")
	assert_gt(water_target_fishing.get_score(), -1, "score >= 0")

	water_target_fishing.queue_free()

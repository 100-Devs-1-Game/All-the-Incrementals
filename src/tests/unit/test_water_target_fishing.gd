extends "res://addons/gut/test.gd"


func test_water_target_fishing_run() -> void:
	var minigame_data: MinigameData = load(
		"res://modules/minigame/water_target_fishing/data/water_fishing_data.tres"
	)

	var minigame: WTFMinigame = (
		load("res://modules/minigame/water_target_fishing/water_target_fishing.tscn").instantiate()
	)

	SceneLoader._current_minigame = minigame_data
	SceneLoader.enable_immediate_play()
	minigame.data = minigame_data

	print("Adding child")
	add_child_autofree(minigame)

	print("Simulating")
	gut.simulate(minigame, 10, .1)
	await wait_seconds(3)

	print("Assert")
	assert_gt(minigame._distance_travelled, 0.0, "distance >= 0")
	assert_gt(minigame.get_score(), -1, "score >= 0")

	minigame.queue_free()

extends "res://addons/gut/test.gd"


func test_water_rowing_rapids() -> void:
	var minigame_data: MinigameData = load(
		"res://modules/minigame/water_rowing_rapids/data/water_rowing_rapids_data.tres"
	)

	var minigame: WaterRowingRapidsMinigame = (
		load("res://modules/minigame/water_rowing_rapids/water_rowing_rapids.tscn").instantiate()
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
	assert_gt(minigame.get_score(), -1, "score >= 0")

	minigame.queue_free()

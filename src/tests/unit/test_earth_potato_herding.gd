extends "res://addons/gut/test.gd"


func test_earth_potato_herding() -> void:
	var minigame_data: MinigameData = load(
		"res://modules/minigame/earth_potato_herding/data/earth_potato_herding_data.tres"
	)

	var minigame: EarthPotatoHerdingMinigame = (
		load("res://modules/minigame/earth_potato_herding/earth_potato_herding.tscn").instantiate()
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

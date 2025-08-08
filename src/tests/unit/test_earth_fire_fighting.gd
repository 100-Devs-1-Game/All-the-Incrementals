extends "res://addons/gut/test.gd"


func test_earth_fire_fighting_run() -> void:
	var earth_fire_fighting_data: MinigameData = load(
		"res://modules/minigame/fire_fighters/data/fire_fighters_data.tres"
	)

	var earth_fire_fighting: FireFightersMinigame = (
		load("res://modules/minigame/fire_fighters/fire_fighters_minigame.tscn").instantiate()
	)

	SceneLoader._current_minigame = earth_fire_fighting_data
	SceneLoader.enable_immediate_play()
	earth_fire_fighting.data = earth_fire_fighting_data

	print("Adding child")
	add_child_autofree(earth_fire_fighting)

	print("Simulating")
	gut.simulate(earth_fire_fighting, 10, .1)
	await wait_seconds(1)

	print("Assert")
	assert_gt(earth_fire_fighting.fires.size(), 0, "fires > 0")

	earth_fire_fighting.queue_free()

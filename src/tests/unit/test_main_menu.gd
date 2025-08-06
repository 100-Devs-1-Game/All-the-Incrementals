extends "res://addons/gut/test.gd"


func test_main_menu() -> void:
	var main_menu = load("res://modules/menu/main_menu.tscn").instantiate()

	print("Adding child")
	add_child_autofree(main_menu)

	print("Simulating")
	gut.simulate(main_menu, 10, .1)
	await wait_seconds(1)

	print("Assert")
	assert_eq(main_menu.name, "MainMenu", "todo: replace with real assert")

	main_menu.queue_free()

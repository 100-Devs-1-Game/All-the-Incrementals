extends Control

const CREDITS_TEXT = """
[center]
Thanks for playing SpiritKeeper!

Hope you enjoyed it!

[font_size=90][outline_size=25][b]Contributors ✨[/b][/outline_size][/font_size]
Thanks goes to all these wonderful people ❤️

[font_size=70][outline_size=25][b]Lead Project Owner[/b][/outline_size][/font_size]
Codimon

[font_size=70][outline_size=25][b]Lead Game Designer[/b][/outline_size][/font_size]
Noxalas

[font_size=70][outline_size=25][b]Art[/b][/outline_size][/font_size]
Axureé
Hannah Sekerka
JMC-87
KLIPNITY
Skin
Turtle

[font_size=70][outline_size=25][b]Code[/b][/outline_size][/font_size]
AssortedFrogs
Cdw849
CodeLitschi (Kevin)
Codimon
ErnestasK760
microlancer
Mouse Potato Does Stuff
niconorsk
Noxalas
Rokle
Sarian
Thaeta-Of-Diamonds
UwUMacaroniTime
Zephilinox

[font_size=70][outline_size=25][b]Narrative[/b][/outline_size][/font_size]
Chris Smith
Nixulus (Lead)

[font_size=70][outline_size=25][b]Operations[/b][/outline_size][/font_size]
alienteavend
Codimon
krova
microlancer
niconorsk
Zephilinox

[font_size=70][outline_size=25][b]Quality Assurance[/b][/outline_size][/font_size]
Duncan

[font_size=70][outline_size=25][b]Sound[/b][/outline_size][/font_size]
4tenmu
Ben Thomson
Fae (Lead composer)
Frog
"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CreditsText.text = CREDITS_TEXT
	var tween = get_tree().create_tween()
	tween.tween_property(
		$CreditsText, "position", Vector2($CreditsText.position.x, -$CreditsText.size.y), 100
	)
	tween.tween_property($DarkGradient, "modulate", Color(1, 1, 1, 0), 5)
	tween.tween_interval(0.05)
	tween.tween_callback($DarkGradient.queue_free)
	tween.tween_interval(5)
	tween.tween_callback(_done)
	$Background.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _done() -> void:
	SceneLoader.enter_extras()


func _input(event):
	if event.is_action_pressed("exit_menu"):
		print("Credits canceled :(")
		_done()

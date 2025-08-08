class_name FillButton
extends Control
signal fill_complete(fill_button: FillButton)

var tween: Tween
var fill_time := 0.5
var is_pressed := false
var switch := false

@onready var button: Button = $UpgradeButton
@onready var filler: ColorRect = $Filler
@onready var particles: GPUParticles2D = $Particles
@onready var particles_copy: GPUParticles2D


func _ready():
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)
	filler.size.x = 0.0
	particles_copy = $Particles.duplicate(DUPLICATE_USE_INSTANTIATION)
	add_child(particles_copy)


func trigger_again() -> void:
	if is_pressed:
		_reset()
		_animate_filler()


func _on_button_down():
	is_pressed = true
	_animate_filler()


func _on_button_up():
	is_pressed = false
	_reset()


func _animate_filler():
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	var target_width = button.size.x
	tween.tween_property(filler, "size:x", target_width, fill_time)
	tween.tween_callback(_trigger)


func _reset():
	tween.kill()
	filler.size.x = 0


func _trigger():
	emit_signal("fill_complete", self)
	if switch:
		particles.restart()
	else:
		particles_copy.restart()
	switch = !switch

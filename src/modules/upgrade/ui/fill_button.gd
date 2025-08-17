class_name FillButton
extends Control
signal fill_complete(fill_button: FillButton)

var tween: Tween
var fill_time := 0.5
var is_pressed := false
var switch := false
var to_poor := false

@onready var button: Button = $UpgradeButton
@onready var filler: ColorRect = $Filler
@onready var particles: GPUParticles2D = $Particles
@onready var particles_copy: GPUParticles2D
@onready var upgrade_audio: AudioStreamPlayer = $Audio
@onready var upgrade_audio_copy: AudioStreamPlayer
@onready var deny_audio: AudioStreamPlayer = $DenyAudio


func _ready():
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)
	filler.size.x = 0.0
	particles_copy = $Particles.duplicate(DUPLICATE_USE_INSTANTIATION)
	upgrade_audio_copy = $Audio.duplicate(DUPLICATE_USE_INSTANTIATION)
	add_child(particles_copy)
	add_child(upgrade_audio_copy)


func trigger_again() -> void:
	if is_pressed:
		reset()
		_animate_filler()


func _on_button_down():
	if to_poor:
		deny_audio.play(0.0)
		return
	is_pressed = true
	_animate_filler()


func _on_button_up():
	is_pressed = false
	switch = !switch
	reset()


func _animate_filler():
	if switch:
		upgrade_audio_copy.play(0.0)
	else:
		upgrade_audio.play(0.0)
	if tween != null:
		tween.kill()
	tween = get_tree().create_tween().bind_node(self)
	var target_width = button.size.x
	tween.tween_property(filler, "size:x", target_width, fill_time)
	tween.tween_callback(_trigger)


func reset():
	if tween != null:
		tween.kill()
	filler.size.x = 0
	if $UpgradeButton.visible == false:
		return
	if !particles_copy.emitting:
		upgrade_audio_copy.stop()
	if !particles.emitting:
		upgrade_audio.stop()


func _trigger():
	emit_signal("fill_complete", self)
	if switch:
		particles.restart()
	else:
		particles_copy.restart()
	switch = !switch

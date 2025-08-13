extends Light3D

@export var base_energy := 5.0
@export var flicker_amplitude := 1.0
@export var flicker_speed := 1.5
@export var flicker_offset := 0.0

@warning_ignore("unused_parameter")
func _process(_delta):
	var t = Time.get_ticks_msec() / 1000.0 + flicker_offset
	var wave = sin(t * flicker_speed)
	var flicker_value = base_energy + wave * flicker_amplitude

	if "light_energy" in self:
		self.light_energy = flicker_value
	elif "energy" in self:
		self.energy = flicker_value

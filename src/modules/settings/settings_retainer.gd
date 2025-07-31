extends Node

#Just keeps track of saved settings

var fullscreen := false
var quality := "Best"
var sfx_volume := 50.0
var music_volume := 50.0
var master_volume := 50.0

var keybinds := {
	"primary_action": [KEY_SPACE, KEY_Z],
	"secondary_action": [KEY_E, KEY_X],
	"right": [KEY_D, KEY_RIGHT],
	"down": [KEY_S, KEY_DOWN],
	"left": [KEY_A, KEY_LEFT],
	"up": [KEY_W, KEY_UP],
	"exit_menu": [KEY_ESCAPE, KEY_C],
}

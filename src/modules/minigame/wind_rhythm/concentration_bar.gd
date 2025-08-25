class_name ConcentrationBar
extends Control

signal concentration_broken

const JUDGMENT = preload("res://modules/minigame/wind_rhythm/chart/judgments.gd").Judgment

@export var drain_speed_base: float = 10
@export var great_play_pause_timer_amount: float = 0.1
@export var perfect_play_pause_timer_amount: float = 0.5
@export var okay_play_loss_amount: float = -2
@export var miss_loss_amount: float = -5

var drain_speed_mult: float = 1.0
var concentration_max_mult: float = 1.0
var perfect_play_bonus: float = 0

var _is_draining: bool = true

@onready var drain_pause_timer: Timer = $DrainPauseTimer
@onready var progress_bar: ProgressBar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drain_pause_timer.connect("timeout", _on_timeout)
	progress_bar.max_value *= concentration_max_mult
	progress_bar.value = progress_bar.max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if _is_draining:
		#progress_bar.value -= drain_speed_base * drain_speed_mult * delta
		progress_bar.value += 0
		#print(drain_speed_base * drain_speed_mult * delta)
	if progress_bar.value <= 0:
		concentration_broken.emit()


func apply_impulse(amount: float):
	progress_bar.value += amount


func pause_draining(amount: float):
	drain_pause_timer.start(amount)
	_is_draining = false


func on_note_missed(_note: NoteData):
	apply_impulse(miss_loss_amount)


func on_note_played(_note: NoteData, judgment: JUDGMENT):
	if judgment == JUDGMENT.OKAY:
		apply_impulse(okay_play_loss_amount)
	elif judgment == JUDGMENT.GREAT:
		pause_draining(great_play_pause_timer_amount)
	elif judgment == JUDGMENT.PERFECT:
		pause_draining(perfect_play_pause_timer_amount + perfect_play_bonus)


func _on_timeout():
	_is_draining = true

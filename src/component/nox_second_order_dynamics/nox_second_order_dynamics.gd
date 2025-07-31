class_name NoxSecondOrderDynamics extends RefCounted

## A utility script for physics-based animations.
##
## Original implementation and idea by t3ssel8r. [br]
## A second-order dynamic system simulating spring-damper behavior
## to smooth transitions over time. [br]
## Useful for animations, camera movements,
## or any system that requires smooth interpolation with responsive behavior. [br]
## This implementation is _type-agnostic,
## currently supporting [code]float[/code], [code]int[/code], and [code]Vector2[/code].
##
## Example usage:
## [codeblock lang=gdscript]
## var smoother := SecondOrderDynamics.new(2.0, 0.5, 1.0, Vector2.ZERO)
##
## func _physics_process(delta):
##     var target_position = player.global_position
##     var smoothed_position = smoother.update(delta, target_position)
##     camera.position = smoothed_position
## [/codeblock]
##
## f is the frequency (Hz). It controls how quickly the system responds.
## Higher values = faster response. [br]
## z is the damping coefficient (0–INF). It controls how quickly the system settles.
## Higher values = less oscillation. [br]
## r is the initial response strength.
## It controls how much the system initially reacts: [br]
## - 0: Starts slowly (lagged response) [br]
## - 1: Critically damped (no overshoot) [br]
## - >1: Overshoots (snappy/anticipating response) [br]
## - <1: Undershoots (sluggish response) [br]

const SUPPORTED_TYPES := [TYPE_FLOAT, TYPE_INT, TYPE_VECTOR2, TYPE_VECTOR3]

var _xp: Variant
var _y: Variant
var _yd: Variant

var _k1: float
var _k2: float
var _k3: float

var _type: int


## f is the frequency (Hz). It controls how quickly the system responds.
## Higher values = faster response. [br]
## z is the damping coefficient (0–INF). It controls how quickly the system settles.
## Higher values = less oscillation. [br]
## r is the initial response strength. It controls how much the system initially reacts.
func _init(f: float, z: float, r: float, x0: Variant) -> void:
	calculate(f, z, r, x0)


## Called upon being initialized. Can be called again to change how the system responds.
func calculate(f: float, z: float, r: float, x0: Variant) -> void:
	# compute constants
	_k1 = z / (PI * f)
	_k2 = 1.0 / ((2.0 * PI * f) * (2.0 * PI * f))
	_k3 = r * z / (2.0 * PI * f)

	# initialize variables
	_xp = x0
	_y = x0
	_type = typeof(x0)

	assert(_type in SUPPORTED_TYPES, "SecondOrderDynamics variable _type not supported")

	match _type:
		TYPE_FLOAT:
			_yd = 0.0
		TYPE_INT:
			_yd = 0
		TYPE_VECTOR2:
			_yd = Vector2.ZERO
		TYPE_VECTOR3:
			_yd = Vector3.ZERO


## Updates the state based on elapsed time and a target value.
## [code]xd[/code] is an optional velocity, if not set, the system estimates it.
func update(t: float, x, xd = null) -> Variant:
	var estimate_xd := func():
		_xp = x
		match _type:
			TYPE_FLOAT, TYPE_INT, TYPE_VECTOR2, TYPE_VECTOR3:
				return (x - _xp) / t
			_:
				return null

	if xd == null:
		xd = estimate_xd.call()

	var k2_stable: float = max(_k2, 1.1 * (t * t / 4.0 + t * _k1 / 2.0))
	_y = _y + t * _yd
	_yd = _yd + t * (x + _k3 * xd - _y - _k1 * _yd) / k2_stable
	return _y

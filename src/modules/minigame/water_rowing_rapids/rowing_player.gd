extends RigidBody2D


## Emitted when the player collects a spirit
signal spirit_collected(value: int)


@export var boost_timer: Timer


## Regular paddling topspeed of boat
var speed: float = 600.0
var boost_impulse: float = 60
var boost_duration: float = 0.3
var is_boosting: bool = false
## Damping applied to velocity on the boat's broadsides- Aka, "apply extra resistance
## to the wide sides of the boat to simulate that boats are not hydrodynamic in
## that direction"
var broadside_resistance: float = 15.0

## Rotation speed of boat at max speed
var rotation_max_speed: float = TAU / 5
## Rotation speed minimum
var rotation_min_speed: float = TAU / 20

var boat_stability := 100.0
var boat_max_stability := 100.0


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	linear_velocity += transform.x * Input.get_axis(&"down", &"up") * speed * linear_damp * delta
	if is_boosting:
		linear_velocity += transform.x * boost_impulse
	for i in get_contact_count():
		_fail()


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var forward_speed := transform.x.dot(state.linear_velocity)
	var broadside_delta := 1 - state.step * broadside_resistance
	var angular_intent: float = Input.get_axis(&"left", &"right")
	var rotation_control: float = (
		-(rotation_max_speed - rotation_min_speed) * min(forward_speed / speed - 1, 1) ** 2
		+ rotation_max_speed
	)
	state.angular_velocity += (angular_intent * rotation_control * angular_damp * state.step)
	# fake conversion of linear into angular
	state.linear_velocity -= (
		transform.x * (abs(angular_intent) * rotation_control * state.step) / rotation_max_speed
	)

	var broadside_speed := transform.y.dot(state.linear_velocity)

	if broadside_delta < 0:
		broadside_delta = 0

	state.linear_velocity -= transform.y * (broadside_speed - broadside_speed * broadside_delta)


func _fail():
	boat_stability -= 10.0


func _boost():
	is_boosting = true
	boost_timer.wait_time = boost_duration
	boost_timer.start()


func _on_boost_timer_timeout() -> void:
	is_boosting = false

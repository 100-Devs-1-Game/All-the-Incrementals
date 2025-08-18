extends RigidBody2D

## Emitted when the player collects a spirit
signal spirit_collected(value: int)

const CONTACT_MINIMUM_VELOCITY: float = 400

@export var ripple_intensity_curve: Curve
@export var boost_timer: Timer

## Regular paddling topspeed of boat
var speed: float = 600.0
var boost_impulse: float = 60
var crit_boost_impulse_mod: float = 0.0
var boost_duration: float = 0.3
# I fucking hate this shit but it's not worth fixing
var is_boosting: bool = false
var is_crit_boosting: bool = false
var rock_crusher: bool = false

var invincibility: float = 0.0

## Damping applied to velocity on the boat's broadsides- Aka, "apply extra resistance
## to the wide sides of the boat to simulate that boats are not hydrodynamic in
## that direction"
var broadside_resistance: float = 15.0

## Rotation speed of boat at max speed
var rotation_max_speed: float = TAU / 5
## Rotation speed minimum
var rotation_min_speed: float = TAU / 20

var boat_max_stability := 100.0
var boat_stability := boat_max_stability
var stability_regen: float = 0.0
var fail_damage: float = 10.0
var crash_damage: float = 10.0

@onready var spirit_magnetism_area: Area2D = $SpiritMagnetismArea
@onready var spirit_magnetism_area_collider: CollisionShape2D = $SpiritMagnetismArea/Collider
@onready var ripple_intensity_scaler: Node2D = %RippleIntensityScaler
@onready var boost_foam_intensity_scaler: Node2D = %FoamIntensityScaler
@onready var rowing_ui: Control = %RowingUI


func _init() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(
		self,
		[
			&"speed",
			&"boost_impulse",
			&"boost_duration",
			&"boat_max_stability",
			&"rotation_max_speed",
			&"rotation_min_speed",
			&"fail_damage",
			&"crash_damage"
		]
	)


func _ready() -> void:
	WaterRowingRapidsMinigameUpgradeLogic.multiregister_base(
		spirit_magnetism_area_collider.shape, [&"radius", &"height"]
	)


func _physics_process(delta: float) -> void:
	boat_stability += stability_regen * delta
	linear_velocity += transform.x * Input.get_axis(&"down", &"up") * speed * linear_damp * delta
	if is_boosting:
		linear_velocity += transform.x * boost_impulse
	if is_crit_boosting:
		linear_velocity += transform.x * boost_impulse * crit_boost_impulse_mod

	if invincibility:
		invincibility = maxf(invincibility - delta, 0)
		return


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var forward_speed := transform.x.dot(state.linear_velocity)
	ripple_intensity_scaler.intensity = ripple_intensity_curve.sample(forward_speed / speed)
	boost_foam_intensity_scaler.intensity = ripple_intensity_curve.sample(
		forward_speed / speed - 1.0
	)

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

	for contact in state.get_contact_count():
		var contact_speed: float = state.get_contact_local_velocity_at_position(contact).length()
		if contact_speed < CONTACT_MINIMUM_VELOCITY:
			continue

		if rock_crusher:
			print("HAS ROCK CRUSHER")
			var collider_rid: RID = state.get_contact_collider(contact)
			print(collider_rid)
			# rocks exist on layer 4 so we discriminate based on that
			if PhysicsServer2D.body_get_collision_layer(collider_rid) & 0b1000:
				(
					instance_from_id(PhysicsServer2D.body_get_object_instance_id(collider_rid))
					. explode()
				)

		if invincibility <= 0:
			take_damage(crash_damage)


func take_damage(amount: float):
	boat_stability -= amount
	invincibility += 0.1


func _fail():
	boat_stability -= fail_damage


func _boost():
	is_boosting = true
	boost_timer.wait_time = boost_duration
	boost_timer.start()


func _on_boost_timer_timeout() -> void:
	is_boosting = false
	is_crit_boosting = false


func _on_sprit_collection_area_spirit_collected(value: int) -> void:
	spirit_collected.emit(value)

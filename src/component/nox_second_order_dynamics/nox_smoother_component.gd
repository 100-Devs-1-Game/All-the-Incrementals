class_name NoxSmootherComponent extends Node

enum SmootherProcessCallback { IDLE, PHYSICS }

## Specifies when the timer is updated during the main loop.
@export var process_callback := SmootherProcessCallback.PHYSICS

## The frequency of the system. Controls how quickly the system responds.
## Higher values = faster response.
@export_range(0.1, 10.0, 0.01) var frequency: float = 1.0:
	set(value):
		frequency = value
		recalculate_values()
## The damping coefficient. It controls how quickly the system settles.
## Higher values = less oscillation.
@export_range(0.1, 10.0, 0.01) var damping: float = 0.5:
	set(value):
		damping = value
		recalculate_values()
## The initial response strength. It controls how much the system initially reacts.
@export_range(-10.0, 10.0, 0.01) var response: float = 1.0:
	set(value):
		response = value
		recalculate_values()

## The node that will be affected by this system.
@export var target_node: Node
## The property that will be changed (e.g., "position", "rotation").
@export var target_property: StringName
## A second property that provides a reference value, such as a "desired_position".
@export var target_reference_property: StringName

var _sod_system: NoxSecondOrderDynamics


func _ready() -> void:
	assert(is_instance_valid(target_node), "Target node must be set.")
	assert(target_node.get(target_property) != null, "Target property must be valid.")

	_sod_system = NoxSecondOrderDynamics.new(
		frequency, damping, response, target_node.get(target_property)
	)


func recalculate_values() -> void:
	if not is_instance_valid(target_node):
		return

	_sod_system.calculate(frequency, damping, response, target_node.get(target_property))


func _process(delta: float) -> void:
	if process_callback != SmootherProcessCallback.IDLE:
		return

	_update_smoothing(delta)


func _physics_process(delta: float) -> void:
	if process_callback != SmootherProcessCallback.PHYSICS:
		return

	_update_smoothing(delta)


func _update_smoothing(delta: float) -> void:
	var reference_value = target_node.get(target_reference_property)

	var smoothed_value = _sod_system.update(delta, reference_value)
	target_node.set(target_property, smoothed_value)

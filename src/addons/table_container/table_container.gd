@tool
@icon("res://addons/table_container/icons/TableContainer.svg")
class_name TableContainer extends VBoxContainer
## A basic extension of [VBoxContainer] that treats [HBoxContainer] children like rows.
##
## The purpose of this class is to keep all nodes within a column the same width.

# ======== Property Helpers ========

# Dictionary of checkable property names. Values are the defaults.
const _checkable_properties: Dictionary = {
	&"update_interval_editor": 60,
	&"update_interval_game": 60,
	&"separation_horizontal": null,
	&"separation_vertical": null,
}


# Update flags of our checkable properties to appropriately set the checkable flags.
func _validate_property(property: Dictionary) -> void:
	if property.name in _checkable_properties:
		property.type = TYPE_INT
		property.usage |= PROPERTY_USAGE_CHECKABLE | PROPERTY_USAGE_DEFAULT
		if get(property.name) != null:
			property.usage |= PROPERTY_USAGE_CHECKED


# Overridden function that indicates which properties get handled by [method _property_get_revert].
func _property_can_revert(property_name: StringName) -> bool:
	return property_name in _checkable_properties


# Overridden function that handles default values for the methods specified in [method _property_can_revert].
func _property_get_revert(property_name: StringName) -> Variant:
	return _checkable_properties.get(property_name)


# ======== Exported Properties ========

## Update interval for the editor, in frames, if [member auto_update_in_editor] is true
@export_range(1, 60) var update_interval_editor = _checkable_properties[&"update_interval_editor"]

## Update interval, in frames, if [member auto_update_in_game] is true
@export_range(1, 60) var update_interval_game = _checkable_properties[&"update_interval_game"]

## Override for horizontal padding between elements, in pixels.
var separation_horizontal = null:
	set(value):
		separation_horizontal = value
		_apply_horizontal_override()

## Override for vertical padding between elements, in pixels.
var separation_vertical = null:
	set(value):
		separation_vertical = value
		_apply_vertical_override()


## Apply separation override to all child [HBoxContainer] rows.
func _apply_horizontal_override() -> void:
	var rows: Array[HBoxContainer] = _get_table_children()
	for row: HBoxContainer in rows:
		if separation_horizontal != null:
			row.add_theme_constant_override("separation", separation_horizontal)
		else:
			row.remove_theme_constant_override("separation")


## Apply separation override to this node.
func _apply_vertical_override() -> void:
	if separation_vertical != null:
		add_theme_constant_override("separation", separation_vertical)
	else:
		remove_theme_constant_override("separation")


# ======== End Exporoted Properties ========

# Update counter used in [member _process] for the editor
var _update_counter_editor: int = 0

# Update counter used in [member _process] for the game
var _update_counter_game: int = 0


func _ready() -> void:
	if Engine.is_editor_hint():
		_update_counter_editor = 0
	else:
		_update_counter_game = 0

	refresh()


## Update the table based on the exported parameters.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if update_interval_editor != null && update_interval_editor > 0:
			if _update_counter_editor == 0:
				refresh()
			_update_counter_editor = (_update_counter_editor + 1) % update_interval_editor
	else:
		if update_interval_game != null && update_interval_game > 0:
			if _update_counter_game == 0:
				refresh()
			_update_counter_game = (_update_counter_game + 1) % update_interval_game


## Update the table sizes manually.
## This is required in-game if [member auto_update_in_game] is false.
func refresh() -> void:
	if _have_uneven_rows():
		push_error("Table has uneven rows. Aborting update.")
		return

	var rows: Array[HBoxContainer] = _get_table_children()
	_clear_custom_column_widths(rows)
	_set_column_widths(rows)
	_apply_horizontal_override()


func _clear_custom_column_widths_for_row(row: HBoxContainer) -> void:
	var cells: Array[Control] = _get_row_children(row)
	for cell: Control in cells:
		cell.custom_minimum_size = Vector2.ZERO


func _clear_custom_column_widths(rows: Array[HBoxContainer]) -> void:
	for row: HBoxContainer in rows:
		_clear_custom_column_widths_for_row(row)


# TODO handle if there's different columns, probably with a warning
func _set_column_widths(rows: Array[HBoxContainer]) -> void:
	var column_widths: Array[float] = []

	var first_row: bool = true
	for row: HBoxContainer in rows:
		var cells: Array[Control] = _get_row_children(row)
		if first_row:
			first_row = false
			for index: int in cells.size():
				var cell: Control = cells[index]
				column_widths.append(cell.get_combined_minimum_size().x)
		else:
			for index: int in cells.size():
				var cell: Control = cells[index]
				var cell_minimum_width: float = cell.get_combined_minimum_size().x
				var column_minimum_width: float = column_widths[index]

				if cell_minimum_width > column_minimum_width:
					column_widths[index] = cell_minimum_width

	for row: HBoxContainer in rows:
		var cells: Array[Control] = _get_row_children(row)
		for index: int in cells.size():
			var cell: Control = cells[index]
			cell.custom_minimum_size.x = column_widths[index]


## Get the table's children as [HBoxContainer] elements. Useful for static typing.
## Note that this filters out non-HBoxContainer nodes.
func _get_table_children() -> Array[HBoxContainer]:
	var children: Array[Node] = get_children().filter(
		func(node: Node) -> bool: return node is HBoxContainer
	)
	var rows: Array[HBoxContainer] = []
	rows.assign(children)
	return rows


## Get a row's children as [Control] elements. Useful for static typing.
## Note that this filters out non-Container nodes.
func _get_row_children(row: HBoxContainer) -> Array[Control]:
	var children: Array[Node] = row.get_children().filter(
		func(node: Node) -> bool: return node is Control
	)
	var cells: Array[Control] = []
	cells.assign(children)
	return cells


# ======== Warnings and Helpers ========


func _have_uneven_rows() -> bool:
	var rows: Array[HBoxContainer] = _get_table_children()
	if rows.size() < 2:
		return false

	var row_lengths: Array = rows.map(func(node: Node) -> int: return node.get_child_count())
	return not row_lengths.all(func(length: int) -> bool: return length == row_lengths.front())


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: Array[String] = []

	var have_bad_children: bool = get_children().any(
		func(node: Node) -> bool: return not node is HBoxContainer
	)

	var have_uneven_rows: bool = _have_uneven_rows()

	if have_bad_children:
		warnings.append("Children of TableContainer should all be HBoxContainer")

	if have_uneven_rows:
		warnings.append("All rows should be the same length")

	return warnings

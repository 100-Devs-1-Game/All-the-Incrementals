extends Area2D

## Emitted when a spirit is collected and consumed [param value] is the "spirit value".
signal spirit_collected(value: int)


func _on_area_entered(area: Area2D) -> void:
	# assume this is a spirt for convenience
	area.owner.queue_free()
	spirit_collected.emit(1)  # TODO: Unhardcode this

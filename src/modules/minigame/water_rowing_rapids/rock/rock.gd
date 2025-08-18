extends StaticBody2D


func explode() -> void:
	var explosion_particles: GPUParticles2D = $ExplosionParticles
	explosion_particles.emitting = true
	$Sprite2D.visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(explosion_particles.lifetime)
	queue_free()

extends ParallaxBackground

func _physics_process(delta):
	$".".scroll_offset.x -= 40 * delta


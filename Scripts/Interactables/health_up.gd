extends Node2D

func _on_area_2d_area_entered(area):
	if area.get_parent() is Player:
		area.get_parent().health += 1
		area.get_parent().update_health_label()
		queue_free()

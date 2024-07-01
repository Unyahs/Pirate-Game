extends CanvasLayer

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		_on_texture_button_pressed()

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/TitleScreen/title_screen.tscn")

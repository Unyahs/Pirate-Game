extends Control

func _ready():
	
	$CanvasLayer/TextureRect/VBoxContainer/HBoxContainer/Play.grab_focus()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/WorldScenes/world_map.tscn")


func _on_about_pressed():
	get_tree().change_scene_to_file("res://Scenes/TitleScreen/about_page.tscn")


func _on_quit_pressed():
	get_tree().quit()

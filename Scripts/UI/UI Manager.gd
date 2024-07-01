extends CanvasLayer



func _ready():
	GameManager.pause_menu = $"Pause Menu"
	GameManager.victory_screen = $VictoryScreen
	GameManager.score_label = $VictoryScreen/Label
	GameManager.gained_coins.connect(update_coin_display)
	$VictoryScreen/Restart.grab_focus()
	
func update_coin_display(gained_coins):
	$"Coin Display".text = str(GameManager.coins)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.pause_play()
		
		get_tree().paused = GameManager.paused

		$"Pause Menu/VBoxContainer/HBoxContainer2/Restart".grab_focus()
		$"Pause Menu/VBoxContainer/HBoxContainer3/World Map".grab_focus()
		$"Pause Menu/VBoxContainer/HBoxContainer4/Quit".grab_focus()
		$"Pause Menu/VBoxContainer/HBoxContainer/Resume".grab_focus()
	

		
func _on_resume_pressed():
	GameManager.resume()

func _on_restart_pressed():
	GameManager.restart()

func _on_world_map_pressed():
	GameManager.load_world()

func _on_quit_pressed():
	GameManager.quit()

func _on_finish_level_pressed():
	GameManager.load_world()

extends StaticBody2D
class_name TotemHead3

@export var score = 300

var totem_spear =load("res://Scenes/Interactables/totem_spear.tscn")
var debris = load("res://Scenes/Interactables/totem_head_3_debris.tscn")

@export var shooting : bool
@export var firerate = 2

@onready var animation_player = $AnimationPlayer
@onready var firepoint = $Firepoint

var max_health = 3
var health


func _ready():
	health = max_health
	shooting = true
	shoot()
	
	
func shoot():
	while shooting:
		animation_player.play("Fire")
		await get_tree().create_timer(firerate).timeout

func fire():
	var spawned_ball = totem_spear.instantiate()
	spawned_ball.direction = firepoint.scale.x
	spawned_ball.global_position = firepoint.position
	add_child(spawned_ball)	
	
	
func take_damage(damage_amount):
	health -= damage_amount
	animation_player.play("Hit")
	if health <= 0:
		die()
		
func die():
	GameManager.score += score
	GameManager.enemies_beaten += 1
	var spawned_debris = debris.instantiate()
	spawned_debris.global_position = position
	spawned_debris.get_child(1).play("Crumble")
	get_tree().get_root().get_child(1).add_child(spawned_debris)
	queue_free()	


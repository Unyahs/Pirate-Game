extends CharacterBody2D
class_name BossTooth
@export var score = 100

@export var speed = -60.0
var current_speed = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var flag = load("res://Scenes/Interactables/endpoint.tscn")
var facing_right = false
var dead = false

@export var max_health = 2
var health
var hit = false
var can_attack = true


func _ready():
	health = max_health
	$AnimationPlayer.play("Run")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
		
	
	velocity.x = speed
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func take_damage(damage_amount):
	if !dead:
		$AnimationPlayer.play("Hit")
		health -= damage_amount
		
		get_node("HealthBar").update_healthbar(health, max_health)
		
		if health <= 0:
			die()

func _on_hitbox_area_entered(area):
	if area.get_parent() is Player  && !dead && can_attack:
		area.get_parent().take_damage(1)
		
func get_hit():
	hit = !hit
	if hit:
		current_speed = speed
		speed = 0
		can_attack = false
	else:
		speed = current_speed
		can_attack = true
		$AnimationPlayer.play("Run")
		
func die():
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		if enemy is Cannon or enemy is TotemHead1 or enemy is TotemHead2 or enemy is TotemHead3:
			enemy.die()
	GameManager.score += score
	GameManager.enemies_beaten += 1
	var spawned_flag = flag.instantiate()
	spawned_flag.global_position = position
	spawned_flag.get_child(1).play("Crumble")
	get_tree().get_root().get_child(1).add_child(spawned_flag)
	dead = true
	speed = 0
	$AnimationPlayer.play("Die")


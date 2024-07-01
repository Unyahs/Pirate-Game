extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var jump_height = -400.0
@export var attacking = false
@onready var health_label = $"../UI Manager/Health"


@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var max_health = 5
var health = 0
var can_take_damage = true
@export var hit = false

func _ready():
	GameManager.damage_taken = 0
	health = max_health
	GameManager.player = self
	update_health_label()
	
func _process(delta):
	if Input.is_action_just_pressed("attack") && !hit:
		attack()
	
func _physics_process(delta):

	
	if Input.is_action_just_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
		$AttackArea.scale.x = abs($Detector.scale.x) * -1
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x) 
		$AttackArea.scale.x = abs($Detector.scale.x) 
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_height
		
	if Input.is_action_just_pressed("down") and is_on_floor():
		position.y += 5

	# Get the input direction and handle the movement/deceleration
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	update_animation()
	move_and_slide()
	
	if position.y >= 700:
		take_damage(1)
		die()

func update_animation():
	if !attacking && !hit:
		if velocity.x != 0:
			animation.play("Run")
		else:
			animation.play("Idle") 
		
		if velocity.y < 0:
			animation.play("Jump")
		if velocity.y > 0:
			animation.play("Fall")

func die():
	GameManager.respawn_player()
	update_health_label()

func attack():
	var overlapping_objects = $AttackArea.get_overlapping_areas()
	
	for area in overlapping_objects:
		if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(1)
		
	attacking = true
	animation.play("Attack")

func take_damage(damage_amount : int):
	if can_take_damage:
		
		iframes()
		hit = true
		attacking = false
		animation.play("Hit")
		
		GameManager.damage_taken += 1
		
		health -= damage_amount
		
		if health <= 0:
			die()
		
		update_health_label()
		
func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true

func update_health_label():
	health_label.text = str(health)

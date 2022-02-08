extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity : Vector2 
export var walk_speed : float
const DEBUG : bool = true

var current_state : String
# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2()
	walk_speed = 400

func player_movement(delta: float):
	velocity = Vector2()
	if Input.is_action_pressed("player_up"):
		velocity += Vector2.UP
	if Input.is_action_pressed("player_down"):
		velocity += Vector2.DOWN
	if Input.is_action_pressed("player_left"):
		velocity += Vector2.LEFT
	if Input.is_action_pressed("player_right"):
		velocity += Vector2.RIGHT
	
	velocity = velocity.normalized()
	
	velocity *= walk_speed
	
	move_and_slide(velocity)


#func player_attack():
#	$light_hitbox.visible = Input.is_action_pressed("light_attack")
#	$heavy_hitbox.visible = Input.is_action_pressed("heavy_attack")


func print_player():
	var player_string := "Player Data: "
	# state data
	player_string += "\n"
	player_string += "Current State: " + current_state
	# attack data
	player_string += "\n"
	player_string += "Light Attack: " + str(Input.is_action_pressed("light_attack"))
	player_string += "\n"
	player_string += "Heavy Attack: " + str(Input.is_action_pressed("heavy_attack"))
	
	$Label.text = player_string

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	#player_movement(delta)
	#player_attack()
	
	if DEBUG:
		print_player()


func _on_StateMachinePlayer_updated(state, delta: float):
	current_state = state
	var smp = get_node("StateMachinePlayer")
	
	match state:
		"Idle":
			player_movement(delta)
			smp.set_param("light_attack", Input.is_action_pressed("light_attack"))
			smp.set_param("heavy_attack", Input.is_action_pressed("heavy_attack"))
		"Light Attack":
			smp.set_param("attack_done", true)
		"Heavy Attack":
			smp.set_param("attack_done", true)

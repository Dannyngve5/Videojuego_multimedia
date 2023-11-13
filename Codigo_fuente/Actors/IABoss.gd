extends Node2D

signal state_changed(new_state)

enum State {
	PATROL, 
	ENGAGE 
}

enum MoveState{
	ENGAGE_DIRECT, 
	ENGAGE_DASH,
	ENGAGE_RANDOM_DIRECTION,
	ENGAGE_SIDE_TO_SIDE
}



onready var player_detection = $PlayerDetection

var current_state: int  = State.PATROL setget set_state
var current_move_state: int = MoveState.ENGAGE_DIRECT setget set_move_state

var player: Player = null 
var weapon: Weapon = null
var actor = null
var is_reloading = false

var movement_direction := Vector2.ZERO	
export (int) var speed = 100


func _ready():
	#weapon.connect("reload_started", self, "_on_reload_started")
	#weapon.connect("reload_finished", self, "_on_reload_finished")
	pass
	
func _on_reload_started():
	is_reloading = true

func _on_reload_finished():
	is_reloading = false


func _process(delta: float) -> void:
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotation = actor.global_position.direction_to(player.global_position).angle()
				movement_direction = global_position.direction_to(player.global_position)
				movement_direction = movement_direction.normalized() 
				actor.move_and_slide(movement_direction * speed)
				weapon.shoot() 
				#and not is_reloading
				if weapon.current_ammo == 0 :
					weapon.start_reload()
			else:
				#print("In the ENGAGE state but no weapon/players")
				pass
		_:
			print("Error: state enemy unknow")
			
func move_pattern(): 
	match current_move_state:
		MoveState.ENGAGE_DIRECT:
			engage_direct_movement()
		MoveState.ENGAGE_DASH:
			engage_dash_movement()
		MoveState.ENGAGE_RANDOM_DIRECTION:
			engage_random_direction_movement()
		MoveState.ENGAGE_SIDE_TO_SIDE:
			engage_side_to_side_movement()
		_:
			print("Error: Unknown engage sub-state")
		
func engage_direct_movement():
	
	pass

func engage_dash_movement():
	pass
	
func engage_random_direction_movement():
	pass

func engage_side_to_side_movement():
	pass

func initialize(actor, weapon: Weapon):
	self.actor = actor
	self.weapon = weapon	
	

func set_state(new_state: int):
	if new_state == current_state:
		return 	
	current_state = new_state
	emit_signal("state_changed", current_state)

func set_move_state(new_state: int):
	pass

func handle_reload():
	weapon.start_reload()
	

func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body 

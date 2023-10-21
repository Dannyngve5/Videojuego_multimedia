extends KinematicBody2D

class_name Player



export (int) var speed = 250

var is_reloading = false
var lives: int = 3
var initial_position: Vector2

onready var weapon: Weapon = $Weapon
onready var health_stat = $Health
onready var team = $Team
onready var pain_sounds = $PainSounds



signal respawn_player




func _ready():
	initial_position = global_position
	weapon.initialize(team.team)
	weapon.connect("reload_started", self, "_on_reload_started")
	weapon.connect("reload_finished", self, "_on_reload_finished")

func _on_reload_started():
	is_reloading = true

func _on_reload_finished():
	is_reloading = false

#Función que es llamada cada frame
func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO	
	if Input.is_action_pressed("up"):
		movement_direction.y = -1
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
	if Input.is_action_pressed("left"):
		movement_direction.x = -1 
	
	movement_direction = movement_direction.normalized() 
	move_and_slide(movement_direction * speed)
	
	look_at(get_global_mouse_position())
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and not is_reloading:
		weapon.shoot()
		
		
	elif event.is_action_released("reload") and not is_reloading:
		weapon.start_reload()

	
func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		lose_life()
	else:
		var sound_index = randi() % 5  # Genera un índice aleatorio entre 0 y 4
		var sound_to_play = pain_sounds.get_child(sound_index)
		if sound_to_play is AudioStreamPlayer2D:
			sound_to_play.play()
		
		
func reload(): 
	weapon.start_reload()
			
func get_team() -> int:
	return team.team
	
func lose_life():
	lives -= 1
	if lives <= 0:
		# Aquí se realizarían las acciones para cuando el jugador se queda sin vidas, como reiniciar el nivel o mostrar una pantalla de game over
		player_death()
		print("Game Over")
	else:
		# Aquí se realizarían las acciones para cuando el jugador pierde una vida pero aún tiene vidas restantes, como reiniciar la posición del jugador o reiniciar la escena
		health_stat.health = 100
		global_position = initial_position
		emit_signal("respawn_player")
		print("Lost a life, remaining lives:", lives)
		#Emitir una señal  
		# Restaurar la salud del jugador u otras acciones necesarias para reiniciar el estado del jugador
	
func player_death():
	self.visible = false  # Desactiva el renderizado del enemigo
	self.collision_layer = 0  # Deshabilita la colisión del enemigo
	self.collision_mask = 0
	
	
	
	
	
		
	

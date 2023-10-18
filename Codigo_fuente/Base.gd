extends Area2D

var base_color = Color(0.443137, 0.870588, 0.117647)
var neutral_color = Color(1, 1, 1)

onready var base_timer = $BaseTimer
onready var sprite = $Sprite

var stored_time = 0.0
var in_zone = false

func _ready():
	pass

func _on_Base_body_entered(body):
	if body.is_in_group("player"):
		in_zone = true
		if stored_time > 0.0:
			base_timer.start(stored_time)
			stored_time = 0.0
		else:
			base_timer.start() 

func _on_Base_body_exited(body):
	if body.is_in_group("player"):
		in_zone = false
		stored_time = base_timer.time_left
		base_timer.stop() 

func _on_BaseTimer_timeout():
	sprite.modulate = base_color
	base_timer.stop()

#Imprime en consola el tiempo (Es para la GUI alguna lógica así seguramente)
func _process(delta: float) -> void:
	if in_zone and base_timer.time_left > 0:
		print(base_timer.time_left)
	elif not in_zone and stored_time > 0:
		print(stored_time)


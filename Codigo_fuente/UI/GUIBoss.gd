extends CanvasLayer

# Verificamos que esten cargados los componentes
# Salud
onready var health_bar = $MarginContainer/Rows/BottomRow/HBoxContainer/HealtBar
# Armas
onready var current_ammo = $CurrentAmmo
onready var max_ammo = $MaxAmmo
# Vidas
onready var current_lifes = $CurrentLifes
#onready var max_lifes = $MarginContainer/Rows/TopRow/HBoxContainer3/MaxLifes
# Tiempo
#onready var time_counter = $MarginContainer/Rows/TopRow/HBoxContainer/TimeCounter

onready var logro1 = $MarginContainer/Rows/BottomRow/HBoxContainer2/logro1
onready var logro2 = $MarginContainer/Rows/BottomRow/HBoxContainer2/logro2
onready var logro3 = $MarginContainer/Rows/BottomRow/HBoxContainer2/logro3


var player: Player
var elapsed_time = 0  # Contador del tiempo transcurrido



func set_player(new_player:Player):
	self.player = new_player
	# Salud
	player.connect("player_health_changed", self, "set_new_health_value")
	# Armas
	player.connect("player_current_ammo_changed", self, "set_current_ammo")
	player.connect("player_max_ammo_changed", self, "set_current_ammo")
	# Vidas
	player.connect("player_current_lifes_changed", self, "set_current_lifes")
	player.connect("player_max_lifes_changed", self, "set_max_lifes")
	# Depuracion
	var parent_node = get_parent()  # Acceder al nodo padre común
	if parent_node.has_node("FinalBoss"):  # Verificar si el nodo FinalBoss2 está bajo el mismo nodo padre
		var final_boss = parent_node.get_node("FinalBoss")  # Obtener una referencia al nodo FinalBoss2
		final_boss.connect("player_depuracion", self, "set_depuracion")
		
	else:
		print("No se encontró el nodo FinalBoss2")
		
	#player.connect("time_counter_changed", self, "set_time_counter")
	if player != null:
		player.emit_initial_signals()
	


func set_new_health_value(new_health: int):
	health_bar.value = new_health
	if new_health < 40:
		health_bar.modulate = Color(1, 0, 0)  # Rojo
	elif new_health < 80:
		health_bar.modulate = Color(1, 1, 0)  # Amarillo
	else:
		health_bar.modulate = Color(0, 1, 0)  # Verde

func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)

func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)

func set_current_lifes(new_current_lifes):
	current_lifes.text = str("x ", new_current_lifes)

func set_max_lifes(new_max_lifes):
	#max_lifes.text = str(new_max_lifes)
	pass

func set_time_counter(new_time_counter):
	#time_counter.text = str(new_time_counter)
	pass

func _on_Timer_timeout():
	elapsed_time += 1  # Aumentamos el contador en uno cada vez que se llama la función
	set_time_counter(elapsed_time)  # Actualizamos el contador en la UI
	


func _on_Timer_timeout_achivement():
	logro1.text = ""
	logro2.text = ""
	logro3.text = ""
	


func _on_FinalBoss_player_depuracion(new_text):
	
	if new_text == "CONSEGUIDO NO HIT": 
		logro1.text = str("-- ",new_text, " --")	
	elif new_text == "CONSEGUDIO ALL LIFES":
		logro2.text = str("-- ",new_text, " --")	
	elif new_text == "CONSEGUDIO HELL KING":
		logro3.text = str("-- ",new_text, " --")	
	$Timer.start()
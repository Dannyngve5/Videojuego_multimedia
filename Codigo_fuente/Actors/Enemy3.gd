extends KinematicBody2D

onready var health_stat = $Health
onready var ia3 = $IA3
onready var team = $Team
onready var attack = $AttackZone

export (int) var damage = 100  
export (float) var attack_cooldown = 1.0

var attacking = false
var current_cooldown = 0.0
var targets = []

func _ready() -> void: 
	ia3.initialize(self)
	attack.connect("body_entered", self, "_on_AttackZone_body_entered")
	attack.connect("body_exited", self, "_on_AttackZone_body_exited")

func handle_hit():
	health_stat.health -= damage 
	if health_stat.health <= 0:
		queue_free()
		
func hit():
	attack.monitoring = true

func end_of_hit():
	attack.monitoring = false

func _on_AttackZone_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		targets.append(body)
		attacking = true
		print("Dentro")
		if current_cooldown <= 0.0:
			_attack()
		else:
			current_cooldown = attack_cooldown

func _on_AttackZone_body_exited(body: Node) -> void:
	if body.is_in_group("player") and targets.has(body):
		targets.erase(body)
		if targets.size() == 0:
			attacking = false
			current_cooldown = 0.0
			print("Saliendo")

func _attack() -> void:
	for target in targets:
		if target.has_method("handle_hit"):
			target.handle_hit()
			print("Collision")
	current_cooldown = attack_cooldown

func _process(delta: float) -> void:
	if attacking and current_cooldown > 0.0:
		current_cooldown -= delta
	else:
		if attacking:
			_attack()

func get_team() -> int:
	return team.team
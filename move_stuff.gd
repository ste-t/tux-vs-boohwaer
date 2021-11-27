extends Node2D

export var speeds := [600.0, 750.0, 900.0, 1200.0]
var speed : float = speeds[0]

var speed_phase : int = 0

func _process(delta: float) -> void:
	if owner.get_node("Tux (RigidBody2D)").is_waiting_for_grounded\
	and owner.get_node("Tux (RigidBody2D)").is_grounded():
		speed_up()

	$Objects.position.x -= speed * delta


func _on_Timer_timeout() -> void:
	speed_up()


func speed_up() -> void:
	if speed_phase < len(speeds) - 1 and\
	owner.get_node("Tux (RigidBody2D)").is_grounded():
		speed_phase += 1

		print_debug("Map speed: ", speed_phase)
		speed = speeds[speed_phase]
		$DefaultEnviorment/TileMap.speed = speed
		$DefaultEnviorment/TileMap2.speed = speed

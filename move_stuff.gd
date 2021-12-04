extends Node2D

export var water: NodePath
#export var speeds := [600.0, 750.0, 900.0, 1200.0]
#var speed : float = speeds[0]

onready var speed : float = Globals.MIN_SPEED

#var speed_phase : int = 0

func _process(delta: float) -> void:
#	if owner.get_node("Tux (RigidBody2D)").is_waiting_for_grounded\
#	and owner.get_node("Tux (RigidBody2D)").is_grounded():
#		speed_up()

	if speed < Globals.MAX_SPEED:
		speed = clamp(speed + (Globals.DELTA_SPEED) / Globals.SPEED_PEAK_TIME * delta, Globals.MIN_SPEED, Globals.MAX_SPEED)
#		print_debug(speed)

	$Objects.translate(Vector2(-speed * delta, 0))
	$Enviorment/Water.translate(Vector2(-speed * delta, 0))

	if $Enviorment/Water.position.x <= -1920.0:
		$Enviorment/Water.position.x = 0.0


#func _on_Timer_timeout() -> void:
#	speed_up()
#
#
#func speed_up() -> void:
#	if speed_phase < len(speeds) - 1 and\
#	owner.get_node("Tux (RigidBody2D)").is_grounded():
#		speed_phase += 1
#
#		print_debug("Map speed: ", speed_phase)
#		speed = speeds[speed_phase]

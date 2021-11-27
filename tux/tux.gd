extends KinematicBody2D

var velocity := Vector2.ZERO
var max_height : float = 743.4
var min_height : float = 80

export var jump_heights := [260.0, 600]
export var jump_times_to_peak := [0.3, 0.3]
export var jump_times_to_descend := [0.5, 0.2]

var speed_phase : int = 0
var is_waiting_for_grounded := true

onready var jump_velocity : float = ((2.0 * jump_heights[0]) / jump_times_to_peak[0]) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_heights[0]) / (jump_times_to_peak[0] * jump_times_to_peak[0])) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_heights[0]) / (jump_times_to_peak[0] * jump_times_to_descend[0])) * -1.0

var flying := false
var hasnt_played_hat_hint := true

var dead : bool = false

func _physics_process(delta: float) -> void:
	if is_waiting_for_grounded and is_grounded():
		speed_up()
	
	velocity.y += get_gravity() * delta

	# Check if jump key is pressed and jump
	if Input.is_action_pressed("jump"):
		if is_grounded():
#			print_debug("jump")
			jump()
		elif flying:
			stop_flying()

	if position.y <= min_height:
		$SoundPowerup.stop()

	velocity = move_and_slide(Vector2.UP * 1200 if flying else velocity, Vector2.UP)
	position.y = clamp(position.y, min_height, max_height)
	animate()  # Animations

func _process(delta: float) -> void:
	owner.get_node("GUI/Top/VBoxContainer/Hat").text = "Hat: %.1f" %\
	$HatTimer.time_left

# Handle animations
func animate() -> void:
	if not dead:
		if is_grounded() or flying:
			$Tux/TuxAnimations.play("swim")
		elif velocity.y < 0.0:
			$Tux/TuxAnimations.play("jump")
		else:
			$Tux/TuxAnimations.play("fall")

func pause() -> void:
	get_tree().paused = true

func fly() -> void:
	flying = true
	$SoundPowerup.play()
	owner.get_node("GUI/Top/VBoxContainer/Hat").visible = true
	$Tux/hat.visible = true
	$HatTimer.start()
	if hasnt_played_hat_hint:
		owner.get_node("GUI/HatHint/AnimationPlayer").play("fadeinout")
		hasnt_played_hat_hint = false

func stop_flying() -> void:
	velocity.y = 0.0
	flying = false
	$Tux/hat.visible = false
	owner.get_node("GUI/Top/VBoxContainer/Hat").visible = false

func die() -> void:
	if !dead:
		dead = true
		owner.get_node("Music").playing = false
		$SoundHurt.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Tux/hat.visible = false
		$Tux/TuxAnimations.play("die")
		owner.get_node("GUI/DeathMenu/AnimationPlayer").play("fadein")

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func jump() -> void:
	velocity.y = jump_velocity
	$SoundJump.play()

func is_grounded() -> bool:
	return position.y >= max_height

func _on_Timer_timeout() -> void:
	if not is_waiting_for_grounded and is_grounded():
		speed_up()
	else:
		is_waiting_for_grounded = true
		print_debug("Waiting for grounded")

	if speed_phase == len(jump_heights) - 1:
		owner.get_node("Timer").queue_free()

func speed_up() -> void:
	if speed_phase < len(jump_heights) - 1:
		speed_phase += 1
		print_debug("Tux speed: ", speed_phase)

	jump_velocity = ((2.0 * jump_heights[speed_phase]) / jump_times_to_peak[speed_phase]) * -1.0
	jump_gravity = ((-2.0 * jump_heights[speed_phase]) / (jump_times_to_peak[speed_phase] * jump_times_to_peak[speed_phase])) * -1.0
	fall_gravity = ((-2.0 * jump_heights[speed_phase]) / (jump_times_to_peak[speed_phase] * jump_times_to_descend[speed_phase])) * -1.0
	
	is_waiting_for_grounded = false

func _on_Area2D_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
	if area.get_child(0).name == "Hat":
		fly()
		area.get_child(0).visible = false
	else:
		die()

func _on_HatTimer_timeout() -> void:
	stop_flying()

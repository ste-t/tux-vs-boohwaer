extends TileMap

var initial_x_position : float = position.x
var speed : float

func _ready() -> void:
	speed = get_parent().get_parent().speed

func _process(delta: float) -> void:
	position.x -= speed * delta  # Move background

	if position.x <= initial_x_position - 1920:
#		print_debug("resetting position")
		position.x = initial_x_position

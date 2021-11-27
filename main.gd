extends Node2D

var objects := []
var hat := preload("res://rare/hat.tscn")

# Minimum and maxium distance between two objects
export var min_gap : float = 600
export var max_gap : float = 960
# Maximum number of objects that can exist at the same time
export var max_objects : int = 6
# Used to make sure no object is spawned on the left of an existing one on first_spawn()
var further_object_position : float = 960

export var hat_rarity : int = 50  # 1 in 50

var random_pos = RandomNumberGenerator.new()
var random_object = RandomNumberGenerator.new()

func _ready() -> void:
	if !(OS.get_name() == "Android" || OS.get_name() == "iOS"):
		$GUI/Top/Hints/HBoxContainder/AnimationPlayer.play("fadeout")

	random_pos.randomize()
	random_object.randomize()

	get_viewport().warp_mouse(Vector2(100.0, 100.0))
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	prepare_objects()
	first_spawn()

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		restart()
	elif Input.is_action_pressed("menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://menu.tscn")

	spawn_objects()

func restart():
	get_tree().reload_current_scene()
	get_tree().paused = false

func first_spawn() -> void:
	while $MovingStuff/Objects.get_child_count() < max_objects:
		var object = objects[random_object.randi_range(0, len(objects) - 1)].instance()

		# X position where the object is gonna be spawned
		var object_position : float = further_object_position + \
		random_pos.randi_range(min_gap, max_gap)  # Generate a random position

		further_object_position = object_position

		object.position = Vector2(object_position, 0.0)
		# Throw em into the scene
		$MovingStuff/Objects.add_child(object)

# Fully handles object spawning
func spawn_objects() -> void:
	if $MovingStuff/Objects.get_child_count() < max_objects:
		var object
		if random_object.randi_range(1, hat_rarity) == 4:
			object = hat.instance()
		else:
			object = objects[random_object.randi_range(0, len(objects) - 1)].instance()

		if $MovingStuff/Objects.get_children()[$MovingStuff/Objects.get_child_count() - 1].position.x >= 1920:
			object.position.x = $MovingStuff/Objects.get_children()[$MovingStuff/Objects.get_child_count() - 1].position.x + random_pos.randi_range(min_gap, max_gap)
		else:
			object.position.x = 1920 + random_pos.randi_range(min_gap, max_gap)
		# Throw em into the scene
		$MovingStuff/Objects.add_child(object)

func prepare_objects() -> void:
		# Objects
		for availabile_object in get_files("res://objects/"):
			objects.append(load("res://objects/" + availabile_object))

func get_files(path: String) -> String:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true)

	var file = dir.get_next()
	while file != "":
		files += [file]
		file = dir.get_next()

	return files

# "By Il mastro Stefanuzzo" button
func _on_Credits_pressed() -> void:
	OS.shell_open("https://www.stefano.ml")


func _on_LinkButton_pressed() -> void:
	restart()


func _on_RestartTouch_pressed() -> void:
	restart()

func _on_MenuTouch_pressed() -> void:
	get_tree().change_scene("res://menu.tscn")
	get_tree().paused = false	

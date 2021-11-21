extends Node2D

func _on_VisibilityNotifier2D_screen_exited() -> void:
#	print_debug("Destroyed")
	queue_free()

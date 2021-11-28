extends Control

func _ready() -> void:
	if !(OS.get_name() == "Android" || OS.get_name() == "iOS"):
		$VBoxContainer/Play.grab_focus()

func _on_Play_pressed() -> void:
	get_tree().change_scene("res://level.tscn")

func _on_Quit_pressed() -> void:
	get_tree().quit()


func _on_Credits2_pressed() -> void:
	OS.shell_open("https://www.stefano.ml")

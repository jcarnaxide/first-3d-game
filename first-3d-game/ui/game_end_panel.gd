extends Control

signal play_again


func _on_play_again_pressed():
	play_again.emit()


func _on_quit_pressed():
	get_tree().quit()

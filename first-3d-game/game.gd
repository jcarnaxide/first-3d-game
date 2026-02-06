extends Node3D

var player_score = 0
var remaining_time = 30

@onready var score = %Score
@onready var remaining_time_label = %RemainingTime
@onready var panel_container = %PanelContainer


func game_won():
	get_tree().paused = true
	panel_container.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func increase_score():
	player_score += 1
	score.text = "Score: %s" % player_score


func decrement_time():
	remaining_time -= 1
	remaining_time_label.text = "Time Left: %s" % remaining_time
	
	if remaining_time == 0:
		game_won()


func do_poof(mob_global_position):
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_global_position


func restart():
	get_tree().reload_current_scene.call_deferred()
	get_tree().paused = false


func _on_mob_spawner_3d_mob_spawned(mob):
	mob.health_depleted.connect(increase_score)
	mob.died.connect(do_poof.bind(mob.global_position))
	do_poof(mob.global_position)


func _on_area_3d_body_entered(body):
	restart()


func _on_timer_timeout():
	decrement_time()


func _on_play_again_button_pressed():
	restart()


func _on_quit_button_pressed():
	get_tree().quit()

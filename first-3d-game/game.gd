extends Node3D

var player_score = 0
@onready var label = %Label


func increase_score():
	player_score += 1
	label.text = "Score: %s" % player_score


func do_poof(mob_global_position):
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_global_position


func _on_mob_spawner_3d_mob_spawned(mob):
	mob.health_depleted.connect(increase_score)
	mob.died.connect(do_poof.bind(mob.global_position))
	do_poof(mob.global_position)


func _on_area_3d_body_entered(body):
	get_tree().reload_current_scene.call_deferred()

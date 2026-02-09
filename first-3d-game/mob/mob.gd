extends RigidBody3D

signal health_depleted
signal died

var health = 3
var speed = randf_range(2.0, 4.0)
var can_attack = true

@onready var bat_model = %bat_model
@onready var death_timer = %DeathTimer
@onready var attack_timer = %AttackTimer
@onready var hurt_sound = %HurtSound
@onready var die_sound = %DieSound
@onready var player = get_node("/root/Game/Player")
@onready var hitbox = %Hitbox


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	linear_velocity = direction * speed
	rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
	if can_attack:
		for body in hitbox.get_overlapping_bodies():
			if body.is_in_group("player") and body.has_method("take_damage"):
				can_attack = false
				body.take_damage()
				attack_timer.start()


func take_damage():
	if health == 0:
		return

	bat_model.hurt()
	health -= 1
	hurt_sound.play()

	if health == 0:
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -1.0 * global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf_range(1.0, 5.0)
		apply_central_impulse(direction * 10.0 + random_upward_force)
		death_timer.start()
		die_sound.play()
		health_depleted.emit()


func _on_death_timer_timeout():
	queue_free()
	died.emit()


func _on_attack_timer_timeout():
	can_attack = true

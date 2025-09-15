extends CharacterBody2D

@onready var collision_sound: AudioStreamPlayer = $collisionSound

var speed: int = 800
var direction: int = -1
var angle_factor: int = 10
var collision_

func _physics_process(_delta: float) -> void:
	if is_on_floor() or is_on_ceiling():
		velocity.y *= -1
	if is_on_wall():
		direction *= -1
	velocity.x = direction * speed
	collision_ = get_last_slide_collision()
	if collision_:
		velocity.y = (transform.origin.y - collision_.get_collider().position.y) * angle_factor
		pitch_randomiser(collision_sound)
	move_and_slide()

func pitch_randomiser(sound:AudioStreamPlayer):
	sound.pitch_scale = randf_range(0.85, 1.15)
	sound.play()

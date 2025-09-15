extends Control

@onready var left_paddle: CharacterBody2D = $CanvasLayer/LeftPaddle
@onready var right_paddle: CharacterBody2D = $CanvasLayer/RightPaddle
@onready var left_pad_score: Label = $CanvasLayer/LeftPadScore
@onready var right_pad_score: Label = $CanvasLayer/RightPadScore
@onready var ball_path = preload("res://scenes and scripts/ball.tscn")
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var score_sound: AudioStreamPlayer = $scoreSound


var ball_spawn_position = Vector2(579, 337)
var left_score : int = 0
var right_score : int = 0
var speed: int = 500

func _physics_process(_delta: float) -> void:
	left_paddle.velocity.y = 0
	right_paddle.velocity.y = 0
	if Input.is_action_pressed("up_leftpad"):
		left_paddle.velocity.y = -speed
	elif Input.is_action_pressed("down_leftpad"):
		left_paddle.velocity.y = speed
	if Input.is_action_pressed("up_rightpad"):
		right_paddle.velocity.y = -speed
	if Input.is_action_pressed("down_rightpad"):
		right_paddle.velocity.y = speed
	left_paddle.move_and_slide()
	right_paddle.move_and_slide()

func pitch_randomiser(sound:AudioStreamPlayer):
	sound.pitch_scale = randf_range(0.85, 1.15)
	sound.play()

func _on_left_ball_detector_body_entered(body: Node2D) -> void:
	body.queue_free()
	right_score +=1
	right_pad_score.text = str(right_score)
	pitch_randomiser(score_sound)
	get_tree().set_pause(true)
	await score_sound.finished
	get_tree().set_pause(false)
	restart()

func _on_right_ball_detector_body_entered(body: Node2D) -> void:
	body.queue_free()
	left_score += 1
	left_pad_score.text = str(left_score)
	pitch_randomiser(score_sound)
	get_tree().set_pause(true)
	await score_sound.finished
	get_tree().set_pause(false)
	restart(true)

func restart(flip_dir:bool=false):
	var ball = ball_path.instantiate()
	canvas_layer.call_deferred("add_child", ball)
	ball.global_position = ball_spawn_position
	if flip_dir:
		ball.direction = 1

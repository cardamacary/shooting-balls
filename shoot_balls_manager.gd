extends Node2D

const BALL = preload("uid://fahqrwuycj6")

@onready var ball_shooting_audio: AudioStreamPlayer = $"ball shooting audio"
@onready var shoot_balls_timer: Timer = $"shoot balls timer"
@export var difficulty_increment:float = 0.005
var counter:float = 1

func _on_shoot_balls_timer_timeout() -> void:
	counter += difficulty_increment
	shoot_balls_timer.wait_time = 0.5 / counter
	shoot()

func shoot()->void:
	ball_shooting_audio.pitch_scale = randf_range(0.7 ,1.3)
	ball_shooting_audio.play()
	add_child.call_deferred(BALL.instantiate())
	
	

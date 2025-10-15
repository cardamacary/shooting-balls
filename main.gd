extends Node2D

@onready var mouse: Area2D = $ui/mouse
@onready var gameover: Panel = $ui/gameover
@onready var game_over_audio: AudioStreamPlayer = $"ui/gameover/game over audio"

@onready var high_score_label: Label = $"ui/gameover/VBoxContainer/high score label"
@onready var score_label: Label = $ui/score
@onready var score_timer: Timer = $ui/score/Timer
var score:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	mouse.area_entered.connect(_on_mouse_collision, CONNECT_ONE_SHOT)
	mouse.area_exited.connect(_on_mouse_collision, CONNECT_ONE_SHOT)
	score_timer.timeout.connect(_update_score)

func _update_score()->void:
	score+=1
	score_label.text = "Score:  %s" % score

func _on_mouse_collision(area:Area2D)->void:
	area.modulate = Color.RED
	get_tree().paused = true
	gameover.visible = true
	game_over_audio.play()
	high_score_label.text = "High score: %s" % score

func _process(delta: float) -> void:
	pass


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()

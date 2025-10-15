extends Area2D

const varying_angle:float = PI/3.0

@onready var sprite: Sprite2D = $Sprite2D

var base_speed:=Vector2(48.0, 0.0)
var velocity:=Vector2.ONE
var rotation_speed:float = randf_range(-0.03, 0.03)
func _ready() -> void:
	velocity = (base_speed*get_parent().counter).rotated(randf_range(-varying_angle, varying_angle))
	sprite.modulate.r = randf_range(0,1)
	sprite.modulate.g = randf_range(0,1)
	sprite.modulate.b = randf_range(0,1)
	scale = Vector2.ONE * randf_range(1, 1.5)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	rotation += rotation_speed
	

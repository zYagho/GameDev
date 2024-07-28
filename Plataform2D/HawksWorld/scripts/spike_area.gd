extends Area2D

@onready var texture := $texture
@onready var collision := $collision


func _ready():
	collision.shape.size = texture.get_rect().size

func _on_body_entered(body):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
		

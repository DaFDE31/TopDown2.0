extends Area2D

class_name Spell

@onready var colliosion_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D =$AnimatedSprite2D

var direction : Vector2
var speed : float
var damage : int 

func init(config: SpellConfig):
	colliosion_shape_2d.shape = config.colllision_shape
	damage = config.damage
	name = config.spell_name
	speed = config.speed
	animated_sprite_2d.play(config.spell_name.to_lower())
	
func _process(delta: float) -> void:
	position += speed *delta *direction

extends Node2D

class_name CombatSystem

signal cast_activeSpell

@onready var animated_sprite_2d: AnimationController = $"../AnimatedSprite2D"

@onready var right_hand_weapon: Sprite2D = $RightHandWeapon
@onready var right_hand_collision_shape_2d: CollisionShape2D = $RightHandWeapon/Area2D/CollisionShape2D

@onready var left_hand_weapon: Sprite2D = $LeftHandWeapon
@onready var left_hand_collision_shape_2d: CollisionShape2D = $LeftHandWeapon/Area2D/CollisionShape2D

@export var right_weapon: WeaponItem
@export var left_weapon: WeaponItem

var can_attack = true

func _ready() -> void:
	animated_sprite_2d.attack_animation_finished.connect(on_attack_animation_finished)

func _input(event):
	
	if Input.is_action_just_pressed("Right_hand_action"):
		perform_attack_action(right_weapon, right_hand_weapon)
		
	if Input.is_action_just_pressed("Left_hand_action"):
		
		perform_attack_action(left_weapon, left_hand_weapon)
		
		
		
func set_active_weapon(weapon: WeaponItem, slot_to_equip: String):
	if slot_to_equip == "Left_Hand":
		if weapon.collision_shape != null:
			left_hand_collision_shape_2d.shape = weapon.collision_shape
		left_hand_weapon.texture = weapon.in_hand_texture
		left_weapon = weapon
	elif slot_to_equip == "Right_Hand":
		if weapon.collision_shape != null:
			right_hand_collision_shape_2d.shape = weapon.collision_shape
		right_hand_weapon.texture = weapon.in_hand_texture
		right_weapon = weapon
func on_attack_animation_finished():
	can_attack = true
	right_hand_weapon.hide()
	left_hand_weapon.hide()

func perform_attack_action(weapon: WeaponItem, sprite: Sprite2D):
	if !can_attack:
		return
	can_attack = false
	animated_sprite_2d.play_attack_animation()
	if weapon == null:
		return
	var attack_direction = animated_sprite_2d.attack_direction
	var attack_data = weapon.get_data_for_direction(attack_direction)
	if weapon.side_in_hand_texture != null && ["left", "right"].has(attack_direction):
		sprite.texture = weapon.side_in_hand_texture
	else:
		sprite.texture = weapon.in_hand_texture
	
	sprite.position = attack_data.get("attachment_position")
	sprite.rotation_degrees = attack_data.get("rotation")
	sprite.z_index = attack_data.get("z_index")
	sprite.show()
	
	if weapon.attack_type == "Magic":
		cast_activeSpell.emit()

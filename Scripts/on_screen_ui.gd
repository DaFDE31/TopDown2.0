extends CanvasLayer

class_name OnScreenUI

@onready var right_hand_slot: OnScreenEquipmentSlot = %RightHandSlot
@onready var left_hand_slot: OnScreenEquipmentSlot = %LeftHandSlot
@onready var potion_slot: OnScreenEquipmentSlot = %PotionSlot
@onready var spell_slot: OnScreenEquipmentSlot = %SpellSlot
@onready var main_character: MC = $".."
@onready var health_system: HealthSystem = $"../HealthSystem"

@onready var slots_dictionary = {
	"Right_Hand": right_hand_slot,
	"Left_Hand": left_hand_slot,
	"Potions":potion_slot,
	
}

func equip_item(item: InventoryItem, slot_to_equip: String):
	slots_dictionary[slot_to_equip].set_equipment_texture(item.texture)
	
	
func spell_cooldown_activated(cooldown:float):
	spell_slot.on_cooldown(cooldown)
	
	

const HEART_ROW_SIZE = 8
const HEART_OFFSET = 16
@onready var hearts: Sprite2D = $MarginContainer/Hearts

func _ready() -> void:
	# Clear any existing children in case this is called multiple times
	for child in hearts.get_children():
		child.queue_free()
	
	# Generate hearts based on total quarter-hearts (healthManager.life)
	var max_health = main_character.get_health()
	print_debug(max_health)
	var total_hearts = ceil(float(max_health) / 4)
	for i in range(total_hearts):
		var newHeart = Sprite2D.new()
		newHeart.texture = hearts.texture
		newHeart.hframes = hearts.hframes
		newHeart.frame = 4  # Full heart by default
		hearts.add_child(newHeart)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for h in hearts.get_children():
		var index = h.get_index()
		
		
		var x = (index % HEART_ROW_SIZE) * HEART_OFFSET
		var y = floor(index / HEART_ROW_SIZE) * HEART_OFFSET
		h.position = Vector2(x, y)
		
		# Determine heart state based on healthManager.life
		var current_health = health_system.current_health
		#print_debug(current_health)
		var quarter_life = current_health - (index * 4)
		if quarter_life >= 4:
			h.frame = 4  # Full heart
		elif quarter_life > 0:
			h.frame = quarter_life  # Partial heart
		else:
			h.frame = 0  # Empty heart
			
func toggle_spellSlot(is_visible:bool, ui_texture : Texture):
	spell_slot.visible = is_visible
	if is_visible:
		spell_slot.set_equipment_texture(ui_texture)

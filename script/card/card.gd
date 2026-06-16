class_name Card
extends RefCounted

var id : String
var _cost := 1
var texture : Texture2D
var target_drag := true
var title : String
var type : CardType
var description : String
var scaling_data : String # String of scaling data, i e STR (A), DEX (B)
var scaling_data_as_dic

var keywords : Array[String]
var modifiers : Array[CardModifier]

signal played

func _init(_id : String):
	var card = CardDatabase.get_card(_id)
	
	id = card["CARD_ID"]
	
	_cost = card["COST"]
	scaling_data = CardDatabase.get_all_scaling(id)
	scaling_data_as_dic = CardDatabase.get_scaling_as_dic(id)
	texture = card["TEXTURE"]
	type = card["TYPE"]
	target_drag = (type == CardType.ATTACK)
	if card["FORCE_TARGET_DRAG"]:
		target_drag = true
	title = card["CARD_NAME"]
	description = card["DESCRIPTION"]
	
	keywords = card["KEYWORDS"]
	
enum ResolveEffect {
	DISCARD,
	REMOVE
}

func get_description():
	var result = description
	if modifiers.size() > 0:
		var mod_text = "\n"
		
		for modifier in modifiers:
			var stack_text = ("x" + str(modifier.get_stacks()))
			mod_text += "%s (%s)\n" % [modifier.get_name(), stack_text]
		
		result += mod_text	
	return result

func on_discard(context, controller):
	pass
	
func effect_on_resolve(context, controller) -> ResolveEffect:
	return ResolveEffect.DISCARD

func can_play(context: BattleContext) -> bool:
	return context.get_current_energy() >= get_cost()

func play(context: BattleContext, controller: BattleController):
	emit_signal("played")
	pass
	
func get_keywords() -> Array[String]:
	return keywords
	
# For enemies
func get_target_index(total_targets: int, target_index: int) -> Array[int]:
	return get_index_single(total_targets, target_index)

# For allies
func get_buff_target_index(total_targets: int) -> Array[int]:
	return []
	
func get_cost() -> int:
	return _cost

# Callable by subclass

# Index 0 always center target
func get_index_blast(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	if target_index != 0:
		result.append(target_index - 1)
	if target_index != total_targets - 1:
		result.append(target_index + 1)
	
	return result

# Index 0 always selected target
func get_index_aoe(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	for i in range(total_targets):
		if not i == target_index:
			result.append(i)
	
	return result
		
func get_index_single(total_targets: int, target_index: int) -> Array[int]:
	var result : Array[int] = [target_index]
	
	return result
	
func get_index_buff_single_target(total_targets: int) -> Array[int]:
	return [ 0 ]
	
static func get_card_type_as_string(type: CardType) -> String:
	match type:
		CardType.ATTACK:
			return "Attack"
		CardType.BUFF:
			return "Buff"
		CardType.DEFENSE:
			return "Defense"
	return "Cannot Find Type"
	
static func get_string_as_card_type(string) -> CardType:
	match string:
		"ATTACK":
			return CardType.ATTACK
		"BUFF":
			return CardType.BUFF
		"DEFENSE":
			return CardType.DEFENSE
	return CardType.ATTACK

enum CardType {
	ATTACK,
	BUFF,
	DEFENSE
}

func get_primary_attribute():
	var max = 0
	var attribute = "Neutral"
	
	for key in scaling_data_as_dic:
		var amount = scaling_data_as_dic[key]
		if(amount > max):
			max = amount
			attribute = key
	
	return attribute

func add_modifier(modifier : CardModifier, context:BattleContext, controller:BattleController):
	for m in modifiers:
		if m.id == modifier.id:
			m.stacks += modifier.stacks
			return
			
	modifiers.append(modifier)
	modifier.set_owner(self)
	modifier.on_apply(self, context, controller)
